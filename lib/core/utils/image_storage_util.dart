import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class ImageStorageUtil {
  static const String IMAGE_DIR = 'product_images';

  static Future<String> getFullPath(String path) async {
    if (path.startsWith('/var/mobile') ||
        path.startsWith('/private/var/mobile')) {
      return path;
    }

    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/$path';
  }

  static String getRelativePath(String fullPath) {
    if (fullPath.startsWith(IMAGE_DIR)) {
      return fullPath;
    }

    final fileName = path.basename(fullPath);
    return '$IMAGE_DIR/$fileName';
  }

  static Future<String> saveImage(File imageFile) async {
    try {
      debugPrint('원본 이미지 경로: ${imageFile.path}');

      if (!await imageFile.exists()) {
        throw Exception('원본 이미지 파일이 존재하지 않습니다');
      }

      final directory = await getApplicationDocumentsDirectory();
      debugPrint('앱 문서 디렉토리: ${directory.path}');

      final imageDir = Directory('${directory.path}/$IMAGE_DIR');
      if (!await imageDir.exists()) {
        await imageDir.create(recursive: true);
      }

      final fileName =
          'product_${DateTime.now().millisecondsSinceEpoch}${path.extension(imageFile.path)}';
      final relativePath = '$IMAGE_DIR/$fileName';
      final fullPath = '${directory.path}/$relativePath';

      await imageFile.copy(fullPath);

      if (!await File(fullPath).exists()) {
        throw Exception('이미지 저장 실패');
      }

      debugPrint('이미지 저장 성공 - 상대경로: $relativePath');
      return relativePath;
    } catch (e, stackTrace) {
      debugPrint('이미지 저장 오류: $e');
      debugPrint(stackTrace.toString());
      rethrow;
    }
  }

  static Future<bool> checkImageExists(String? path) async {
    if (path == null) return false;
    try {
      if (path.startsWith('/var/mobile')) {
        final file = File(path);
        final exists = await file.exists();
        debugPrint('이미지 존재 확인 (전체 경로) - 경로: $path, 존재: $exists');

        if (!exists && path.contains(IMAGE_DIR)) {
          final relativePath = path.substring(path.indexOf(IMAGE_DIR));
          return checkImageExists(relativePath);
        }
        return exists;
      }

      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$path');
      final exists = await file.exists();
      debugPrint(
          '이미지 존재 확인 (상대 경로) - 경로: $path, 전체 경로: ${file.path}, 존재: $exists');
      return exists;
    } catch (e) {
      debugPrint('이미지 존재 확인 오류: $e');
      return false;
    }
  }

  static Future<void> deleteImage(String? relativePath) async {
    if (relativePath == null) return;
    try {
      final fullPath = await getFullPath(relativePath);
      final file = File(fullPath);
      if (await file.exists()) {
        await file.delete();
        debugPrint('이미지 삭제 완료: $relativePath');
      }
    } catch (e) {
      debugPrint('이미지 삭제 오류: $e');
    }
  }
}
