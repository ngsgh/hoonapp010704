import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import '../../../../core/utils/image_storage_util.dart';
import '../../../home/domain/models/product.dart';

class BackupProvider with ChangeNotifier {
  final Box<Product> _productBox = Hive.box<Product>('products');
  final Box _settingsBox = Hive.box('settings');
  bool _isBackupEnabled = false;
  DateTime? _lastBackupDate;

  BackupProvider() {
    _loadBackupSettings();
  }

  bool get isBackupEnabled => _isBackupEnabled;
  DateTime? get lastBackupDate => _lastBackupDate;

  Future<void> _loadBackupSettings() async {
    _isBackupEnabled =
        _settingsBox.get('icloud_backup_enabled', defaultValue: false);
    final lastBackupTimestamp = _settingsBox.get('last_backup_date');
    _lastBackupDate = lastBackupTimestamp != null
        ? DateTime.fromMillisecondsSinceEpoch(lastBackupTimestamp)
        : null;
    notifyListeners();
  }

  Future<void> setBackupEnabled(bool value) async {
    _isBackupEnabled = value;
    await _settingsBox.put('icloud_backup_enabled', value);
    if (value) {
      await backup();
    }
    notifyListeners();
  }

  Future<void> backup() async {
    try {
      if (!Platform.isIOS) {
        throw Exception('iCloud 백업은 iOS에서만 가능합니다.');
      }

      // 1. 제품 데이터 백업
      final productsData = _productBox.values
          .map((product) => {
                'name': product.name,
                'category': product.category,
                'location': product.location,
                'expiryDate': product.expiryDate.toIso8601String(),
                'imageUrl': product.imageUrl,
              })
          .toList();

      // 2. 설정 데이터 백업
      final settingsData = {
        'notifications_enabled': _settingsBox.get('notifications_enabled'),
        'days_before_expiry': _settingsBox.get('days_before_expiry'),
        'notification_hour': _settingsBox.get('notification_hour'),
        'notification_minute': _settingsBox.get('notification_minute'),
      };

      // 3. 백업 데이터 생성
      final backupData = {
        'products': productsData,
        'settings': settingsData,
        'backup_date': DateTime.now().toIso8601String(),
      };

      // 4. iCloud 백업 디렉토리 생성
      final appDocDir = await getApplicationDocumentsDirectory();
      final backupDir = Directory('${appDocDir.path}/Backup');
      if (!await backupDir.exists()) {
        await backupDir.create();
      }

      // 5. 백업 파일 생성
      final backupFile = File('${backupDir.path}/backup.json');
      await backupFile.writeAsString(jsonEncode(backupData));

      // 6. 이미지 파일 백업
      for (final product in _productBox.values) {
        if (product.imageUrl != null) {
          final imageFile = File(product.imageUrl!);
          if (await imageFile.exists()) {
            final backupImageFile =
                File('${backupDir.path}/${imageFile.uri.pathSegments.last}');
            await imageFile.copy(backupImageFile.path);
          }
        }
      }

      // 7. 마지막 백업 날짜 저장
      _lastBackupDate = DateTime.now();
      await _settingsBox.put(
          'last_backup_date', _lastBackupDate!.millisecondsSinceEpoch);

      notifyListeners();
    } catch (e) {
      debugPrint('백업 오류: $e');
      rethrow;
    }
  }

  Future<void> restore() async {
    try {
      if (!Platform.isIOS) {
        throw Exception('iCloud 복원은 iOS에서만 가능합니다.');
      }

      // 1. 백업 파일 읽기
      final appDocDir = await getApplicationDocumentsDirectory();
      final backupFile = File('${appDocDir.path}/Backup/backup.json');

      if (!await backupFile.exists()) {
        throw Exception('백업 파일이 없습니다.');
      }

      final backupData = jsonDecode(await backupFile.readAsString());

      // 2. 기존 데이터 삭제
      await _productBox.clear();

      // 3. 제품 데이터 복원
      final productsData =
          List<Map<String, dynamic>>.from(backupData['products']);
      for (final productData in productsData) {
        final product = Product(
          name: productData['name'],
          category: productData['category'],
          location: productData['location'],
          expiryDate: DateTime.parse(productData['expiryDate']),
          imageUrl: productData['imageUrl'],
        );
        await _productBox.add(product);
      }

      // 4. 설정 데이터 복원
      final settingsData = Map<String, dynamic>.from(backupData['settings']);
      for (final entry in settingsData.entries) {
        await _settingsBox.put(entry.key, entry.value);
      }

      // 5. 이미지 파일 복원
      final backupDir = Directory('${appDocDir.path}/Backup');
      for (final product in _productBox.values) {
        if (product.imageUrl != null) {
          final backupImageFile =
              File('${backupDir.path}/${product.imageUrl!.split('/').last}');
          if (await backupImageFile.exists()) {
            final restoredImageFile =
                await ImageStorageUtil.saveImage(backupImageFile);
            final index = _productBox.values.toList().indexOf(product);
            await _productBox.putAt(
                index,
                Product(
                  name: product.name,
                  category: product.category,
                  location: product.location,
                  expiryDate: product.expiryDate,
                  imageUrl: restoredImageFile,
                ));
          }
        }
      }

      notifyListeners();
    } catch (e) {
      debugPrint('복원 오류: $e');
      rethrow;
    }
  }
}
