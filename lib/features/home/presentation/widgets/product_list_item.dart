import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/models/product.dart';

class ProductListItem extends StatelessWidget {
  final Product product;

  const ProductListItem({
    super.key,
    required this.product,
  });

  String _formatDate(DateTime date) {
    return '${date.year}. ${date.month}. ${date.day}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.medium),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.grey300),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.grey300,
              borderRadius: BorderRadius.circular(8),
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
