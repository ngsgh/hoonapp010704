import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTypography {
  static const title = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );

  static const button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static const label = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static const body = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  static final textTheme = TextTheme(
    titleLarge: title.copyWith(color: AppColors.grey900),
    bodyLarge: body.copyWith(color: AppColors.grey900),
    bodyMedium: label.copyWith(color: AppColors.grey700),
    labelLarge: button.copyWith(color: AppColors.primary),
  );
}
