import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class NavBarItem extends StatelessWidget {
  final bool isSelected;

  const NavBarItem({
    super.key,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Container(
        width: AppNavigationBarTheme.iconSize,
        height: AppNavigationBarTheme.iconSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected
              ? AppNavigationBarTheme.activeIconColor
              : AppNavigationBarTheme.inactiveIconColor,
        ),
      ),
    );
  }
}
