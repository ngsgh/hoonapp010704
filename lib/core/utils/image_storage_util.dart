import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class ImageStorageUtil {
  static const String IMAGE_DIR = 'product_images';

  static Future<String> get _documentsDirectory async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<void> _ensureDirectoryExists() async {
    final documentsDir = await _documentsDirectory;
    final imageDirPath = path.join(documentsDir, IMAGE_DIR);
    final imageDir = Directory(imageDirPath);
    if (!await imageDir.exists()) {
      await imageDir.create(recursive: true);
    }
  }

  static Future<String> saveImage(File imageFile) async {
    await _ensureDirectoryExists();
    final documentsDir = await _documentsDirectory;
    final fileName = 'product_${DateTime.now().millisecondsSinceEpoch}.png';
    final imageDirPath = path.join(documentsDir, IMAGE_DIR);
    final savedPath = path.join(imageDirPath, fileName);

    try {
      await imageFile.copy(savedPath);
      print('원본 이미지 경로: ${imageFile.path}');
      print('앱 문서 디렉토리: $documentsDir');
      print('이미지 저장 성공 - 전체경로: $savedPath');

      return savedPath;
    } catch (e) {
      print('이미지 저장 오류: $e');
      rethrow;
    }
  }

  static Future<String> getFullPath(String imagePath) async {
    if (imagePath.startsWith('http')) {
      return imagePath;
    }

    if (imagePath.startsWith('/')) {
      final file = File(imagePath);
      if (await file.exists()) {
        return imagePath;
      }
    }

    await _ensureDirectoryExists();
    final documentsDir = await _documentsDirectory;
    final fullPath =
        path.join(documentsDir, IMAGE_DIR, path.basename(imagePath));

    print('이미지 전체 경로 변환: $imagePath -> $fullPath');
    return fullPath;
  }

  static Future<bool> checkImageExists(String? imagePath) async {
    if (imagePath == null) return false;
    if (imagePath.startsWith('http')) return true;

    try {
      final fullPath = await getFullPath(imagePath);
      final file = File(fullPath);
      final exists = await file.exists();
      print('이미지 존재 확인: $fullPath - ${exists ? "있음" : "없음"}');
      return exists;
    } catch (e) {
      print('이미지 존재 확인 오류: $e');
      return false;
    }
  }

  static Future<void> deleteImage(String? imagePath) async {
    if (imagePath == null) return;
    try {
      final fullPath = await getFullPath(imagePath);
      final file = File(fullPath);
      if (await file.exists()) {
        await file.delete();
        print('이미지 삭제 완료: $fullPath');
      }
    } catch (e) {
      print('이미지 삭제 오류: $e');
    }
  }
}
