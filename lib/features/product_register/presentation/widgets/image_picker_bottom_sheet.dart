import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';

class ImagePickerBottomSheet extends StatelessWidget {
  final VoidCallback onCameraTap;
  final VoidCallback onGalleryTap;

  const ImagePickerBottomSheet({
    super.key,
    required this.onCameraTap,
    required this.onGalleryTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.medium),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt, color: AppColors.grey900),
            title: Text(
              '카메라로 촬영',
              style: AppTypography.body.copyWith(color: AppColors.grey900),
            ),
            onTap: () {
              Navigator.pop(context);
              onCameraTap();
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library, color: AppColors.grey900),
            title: Text(
              '갤러리에서 선택',
              style: AppTypography.body.copyWith(color: AppColors.grey900),
            ),
            onTap: () {
              Navigator.pop(context);
              onGalleryTap();
            },
          ),
        ],
      ),
    );
  }
}
