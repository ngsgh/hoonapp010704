import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/models/product.dart';

class ProductListItem extends StatelessWidget {
  final Product product;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ProductListItem({
    super.key,
    required this.product,
    this.onEdit,
    this.onDelete,
  });

  String _formatDate(DateTime date) {
    return '${date.year}. ${date.month}. ${date.day}';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('상품 관리'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.edit),
                  title: const Text('수정'),
                  onTap: () {
                    Navigator.pop(context);
                    onEdit?.call();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: const Text('삭제', style: TextStyle(color: Colors.red)),
                  onTap: () {
                    Navigator.pop(context);
                    onDelete?.call();
                  },
                ),
              ],
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.medium),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.grey300,
                borderRadius: BorderRadius.circular(10),
                image: product.imageUrl != null
                    ? DecorationImage(
                        image: FileImage(File(product.imageUrl!)),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: product.imageUrl == null
                  ? const Icon(
                      Icons.image_not_supported_outlined,
                      color: AppColors.grey500,
                    )
                  : null,
            ),
            const SizedBox(width: AppSpacing.medium),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: AppTypography.title.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.grey900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        product.category,
                        style: AppTypography.body.copyWith(
                          fontSize: 14,
                          color: AppColors.grey700,
                        ),
                      ),
                      _buildDivider(),
                      Text(
                        product.location,
                        style: AppTypography.body.copyWith(
                          fontSize: 14,
                          color: AppColors.grey700,
                        ),
                      ),
                      _buildDivider(),
                      Text(
                        _formatDate(product.expiryDate),
                        style: AppTypography.body.copyWith(
                          fontSize: 14,
                          color: AppColors.grey700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        '|',
        style: AppTypography.body.copyWith(
          color: AppColors.grey300,
          fontSize: 14,
        ),
      ),
    );
  }
}
