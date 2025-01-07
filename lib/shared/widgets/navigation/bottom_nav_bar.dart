import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import 'nav_bar_item.dart';

class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(
          top: BorderSide(
            color: AppNavigationBarTheme.borderColor,
            width: AppNavigationBarTheme.borderWidth,
          ),
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(Adaptive.radius(context)),
          topRight: Radius.circular(Adaptive.radius(context)),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(0, '홈'),
                _buildNavItem(1, '쇼핑'),
                _buildNavItem(2, '등록'),
                _buildNavItem(3, '레시피'),
                _buildNavItem(4, '상품정보'),
              ],
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, String label) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () => onTap(index),
      child: Container(
        width: 60,
        height: 55,
        child: Column(
          children: [
            const NavBarItem(isSelected: false),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: AppNavigationBarTheme.textSize,
                  fontWeight: currentIndex == index
                      ? FontWeight.w600
                      : FontWeight.normal,
                  color: currentIndex == index
                      ? AppNavigationBarTheme.activeTextColor
                      : AppNavigationBarTheme.inactiveTextColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
