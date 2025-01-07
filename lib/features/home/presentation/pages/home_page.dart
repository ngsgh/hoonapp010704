import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/models/product.dart';
import '../widgets/product_list_item.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text(
          '홈',
          style: AppTypography.title.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.grey900,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<ProductProvider>(
        builder: (context, provider, child) {
          if (provider.products.isEmpty) {
            return const Center(
              child: Text('등록된 상품이 없습니다'),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.medium),
            itemCount: provider.products.length,
            separatorBuilder: (context, index) =>
                const SizedBox(height: AppSpacing.medium),
            itemBuilder: (context, index) => ProductListItem(
              product: provider.products[index],
            ),
          );
        },
      ),
    );
  }
}
