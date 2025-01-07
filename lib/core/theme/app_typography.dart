import 'package:flutter/material.dart';
import '../constants/platform_check.dart';

class AppTypography {
  static TextTheme get textTheme {
    if (PlatformCheck.isIOS) {
      return const TextTheme(
        displayLarge: TextStyle(
          fontFamily: '.SF Pro Display',
          fontSize: 34,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          fontFamily: '.SF Pro Display',
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
        // ... iOS 스타일 계속
      );
    }

    return const TextTheme(
      displayLarge: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 34,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
      // ... Material 스타일 계속
    );
  }
}
