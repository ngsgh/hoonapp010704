import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/image_storage_util.dart';
import '../../domain/models/product.dart';

class ProductListItem extends StatelessWidget {
  final Product product;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final Widget? leading;

  const ProductListItem({
    super.key,
    required this.product,
    required this.onEdit,
    required this.onDelete,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(
          color: AppColors.grey300,
          width: 1,
        ),
      ),
      child: ListTile(
        leading: leading ??
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.grey300,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(
                Icons.image_not_supported_outlined,
                color: AppColors.grey500,
                size: 24,
              ),
            ),
        title: Text(
          product.name,
          style: AppTypography.body.copyWith(
            color: AppColors.grey900,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.location,
              style: AppTypography.caption.copyWith(
                color: AppColors.grey700,
              ),
            ),
            Text(
              '${DateFormat('yyyy년 MM월 dd일').format(product.expiryDate)} ${_getDaysUntilExpiry(product.expiryDate)}',
              style: AppTypography.caption.copyWith(
                color: _getExpiryColor(product.expiryDate),
              ),
            ),
          ],
        ),
        trailing: PopupMenuButton(
          icon: const Icon(
            Icons.more_vert,
            color: AppColors.grey700,
          ),
          itemBuilder: (context) => [
            PopupMenuItem(
              child: const Text('수정'),
              onTap: onEdit,
            ),
            PopupMenuItem(
              child: const Text('삭제'),
              onTap: onDelete,
            ),
          ],
        ),
      ),
    );
  }

  String _getDaysUntilExpiry(DateTime expiryDate) {
    final days = expiryDate.difference(DateTime.now()).inDays;
    if (days < 0) {
      return '(${days.abs()}일 지남)';
    } else if (days == 0) {
      return '(오늘 만료)';
    } else {
      return '($days일 남음)';
    }
  }

  Color _getExpiryColor(DateTime expiryDate) {
    final days = expiryDate.difference(DateTime.now()).inDays;
    if (days < 0) {
      return AppColors.error;
    } else if (days <= 7) {
      return AppColors.warning;
    } else {
      return AppColors.grey700;
    }
  }
}
