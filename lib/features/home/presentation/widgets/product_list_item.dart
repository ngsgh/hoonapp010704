import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/models/product.dart';

class ProductListItem extends StatelessWidget {
  final Product product;

  const ProductListItem({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        boxShadow: AppShadows.card,
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: AppColors.grey100,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppSpacing.medium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: AppTypography.productTitle,
                ),
                const SizedBox(height: AppSpacing.small),
                Row(
                  children: [
                    Text(
                      product.location,
                      style: AppTypography.productInfo,
                    ),
                    Text(
                      ' | ',
                      style: AppTypography.productInfo.copyWith(
                        color: AppColors.grey300,
                      ),
                    ),
                    Text(
                      product.category,
                      style: AppTypography.productInfo,
                    ),
                    Text(
                      ' | ',
                      style: AppTypography.productInfo.copyWith(
                        color: AppColors.grey300,
                      ),
                    ),
                    Text(
                      '${product.expiryDate.year}.${product.expiryDate.month}.${product.expiryDate.day}',
                      style: AppTypography.productInfo,
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
}
