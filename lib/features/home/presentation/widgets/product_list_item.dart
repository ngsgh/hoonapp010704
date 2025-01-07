import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/spacing.dart';
import '../../../../core/constants/typography.dart';
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

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.medium),
        decoration: BoxDecoration(
          color: AppColors.white,
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
                      child: FutureBuilder<bool>(
                        future:
                            ImageStorageUtil.checkImageExists(product.imageUrl),
                        builder: (context, snapshot) {
                          if (snapshot.data == true) {
                            return FutureBuilder<String>(
                              future: ImageStorageUtil.getFullPath(
                                  product.imageUrl!.contains('product_images/')
                                      ? product.imageUrl!.substring(product
                                          .imageUrl!
                                          .indexOf('product_images/'))
                                      : product.imageUrl!),
                              builder: (context, pathSnapshot) {
                                if (pathSnapshot.hasData) {
                                  return Image.file(
                                    File(pathSnapshot.data!),
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      debugPrint('이미지 로드 에러: $error');
                                      debugPrint(
                                          '시도한 경로: ${pathSnapshot.data}');
                                      return const Icon(
                                        Icons.error_outline,
                                        color: AppColors.grey500,
                                      );
                                    },
                                  );
                                }
                                return const CircularProgressIndicator();
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
            if (onEdit != null || onDelete != null) ...[
              PopupMenuButton<String>(
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

  String _formatDate(DateTime date) {
    return '${date.year}. ${date.month}. ${date.day}';
  }
}
