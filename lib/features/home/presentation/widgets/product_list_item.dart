import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/image_storage_util.dart';
import '../../domain/models/product.dart';

class ProductListItem extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ProductListItem({
    super.key,
    required this.product,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  Color _getExpiryColor() {
    final daysUntilExpiry =
        product.expiryDate.difference(DateTime.now()).inDays;
    if (daysUntilExpiry <= 3) {
      return AppColors.primary.withOpacity(0.1);
    } else if (daysUntilExpiry <= 7) {
      return AppColors.primary.withOpacity(0.05);
    }
    return AppColors.white;
  }

  String _getExpiryText() {
    final daysUntilExpiry =
        product.expiryDate.difference(DateTime.now()).inDays;
    if (daysUntilExpiry < 0) {
      return '유통기한 만료';
    } else if (daysUntilExpiry == 0) {
      return '오늘 만료';
    } else {
      return 'D-$daysUntilExpiry';
    }
  }

  Color _getExpiryTextColor() {
    final daysUntilExpiry =
        product.expiryDate.difference(DateTime.now()).inDays;
    if (daysUntilExpiry <= 3) {
      return AppColors.primary;
    }
    return AppColors.grey700;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.medium),
        decoration: BoxDecoration(
          color: _getExpiryColor(),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.grey300,
                borderRadius: BorderRadius.circular(8),
              ),
              child: product.imageUrl == null
                  ? const Icon(
                      Icons.image_not_supported_outlined,
                      color: AppColors.grey500,
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: FutureBuilder<String>(
                        future: ImageStorageUtil.getFullPath(product.imageUrl!),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Image.file(
                              File(snapshot.data!),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.image_not_supported_outlined,
                                  color: AppColors.grey500,
                                );
                              },
                            );
                          }
                          return const Icon(
                            Icons.image_not_supported_outlined,
                            color: AppColors.grey500,
                          );
                        },
                      ),
                    ),
            ),
            const SizedBox(width: AppSpacing.medium),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: AppTypography.body.copyWith(
                      color: AppColors.grey900,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        product.location,
                        style: AppTypography.body.copyWith(
                          color: AppColors.grey700,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: _getExpiryTextColor().withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          _getExpiryText(),
                          style: AppTypography.body.copyWith(
                            color: _getExpiryTextColor(),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (onEdit != null || onDelete != null)
              PopupMenuButton<String>(
                icon: const Icon(
                  Icons.more_vert,
                  color: AppColors.grey700,
                ),
                onSelected: (value) {
                  if (value == 'edit' && onEdit != null) {
                    onEdit!();
                  } else if (value == 'delete' && onDelete != null) {
                    onDelete!();
                  }
                },
                itemBuilder: (context) => [
                  if (onEdit != null)
                    const PopupMenuItem(
                      value: 'edit',
                      child: Text('수정'),
                    ),
                  if (onDelete != null)
                    const PopupMenuItem(
                      value: 'delete',
                      child: Text('삭제'),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
