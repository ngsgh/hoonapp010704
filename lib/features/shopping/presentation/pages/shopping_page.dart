import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';

class ShoppingPage extends StatelessWidget {
  const ShoppingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          '쇼핑',
          style: AppTypography.title.copyWith(
            color: AppColors.grey900,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_bag,
              size: 64,
              color: AppColors.grey500,
            ),
            const SizedBox(height: AppSpacing.medium),
            Text(
              '준비 중인 기능입니다',
              style: AppTypography.body.copyWith(
                color: AppColors.grey700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
