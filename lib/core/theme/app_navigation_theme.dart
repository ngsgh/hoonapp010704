import 'package:flutter/material.dart';

class AppNavigationTheme {
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

class Adaptive {
  static const double _baseWidth = 375.0;
  static const double _baseRadius = 20.0;

  static double radius(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return (screenWidth / _baseWidth) * _baseRadius;
  }

  static const double navigationBarHeight = 56.0;
}
