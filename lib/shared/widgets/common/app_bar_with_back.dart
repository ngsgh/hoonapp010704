import 'package:flutter/material.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_colors.dart';

class AppBarWithBack extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? rightButtonText;
  final VoidCallback? onRightButtonTap;

  const AppBarWithBack({
    super.key,
    required this.title,
    this.rightButtonText,
    this.onRightButtonTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          color: AppColors.black,
          size: 24,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      centerTitle: true,
      title: Text(title, style: AppTypography.header),
      actions: rightButtonText != null
          ? [
              TextButton(
                onPressed: onRightButtonTap,
                child: Text(
                  rightButtonText!,
                  style: AppTypography.body.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ]
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
