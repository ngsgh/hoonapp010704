import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';

class DetailAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String rightButtonText;
  final VoidCallback? onRightButtonTap;

  const DetailAppBar({
    super.key,
    required this.title,
    required this.rightButtonText,
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
          color: AppColors.grey900,
          size: 24,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        title,
        style: AppTypography.title.copyWith(
          color: AppColors.grey900,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: TextButton(
            onPressed: onRightButtonTap,
            style: TextButton.styleFrom(
              minimumSize: Size.zero,
              padding: EdgeInsets.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              rightButtonText,
              style: AppTypography.button.copyWith(
                color: AppColors.primary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
