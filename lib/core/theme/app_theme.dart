import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../constants/platform_check.dart';
import 'app_colors.dart';
import 'app_typography.dart';

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
