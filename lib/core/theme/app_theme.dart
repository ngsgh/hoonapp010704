import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../constants/platform_check.dart';
import 'app_colors.dart';
import 'app_typography.dart';

// 반응형 디자인 시스템
class Adaptive {
  // 기준이 되는 디자인 스펙 (iPhone 8 기준)
  static const double _baseWidth = 375.0;
  static const double _baseRadius = 20.0;

  // 반응형 radius 계산
  static double radius(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return (screenWidth / _baseWidth) * _baseRadius;
  }

  // 네비게이션 바 높이
  static const double navigationBarHeight = 56.0;
}

// 네비게이션 바 전용 테마 (이름 변경)
class AppNavigationBarTheme {
  // 색상
  static const Color borderColor = Color(0xFFF2F2F2);
  static const Color activeIconColor = Color(0xFF7E8186);
  static const Color inactiveIconColor = Color(0xFFD4D7DC);
  static const Color activeTextColor = Color(0xFF7E8186);
  static const Color inactiveTextColor = Color(0xFFD4D7DC);

  // 크기
  static const double borderWidth = 0.5;
  static const double iconSize = 24.0;
  static const double textSize = 12.0;
  static const double itemSpacing = 4.0;
}

class AppTheme {
  static ThemeData get theme {
    if (PlatformCheck.isIOS) {
      return ThemeData(
        platform: TargetPlatform.iOS,
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        textTheme: AppTypography.textTheme,
        cupertinoOverrideTheme: const CupertinoThemeData(
          primaryColor: AppColors.primary,
        ),
        // iOS 특화 설정
      );
    }

    return ThemeData(
      platform: TargetPlatform.android,
      primaryColor: AppColors.primary,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        background: AppColors.background,
      ),
      textTheme: AppTypography.textTheme,
      // Material 특화 설정
    );
  }
}
