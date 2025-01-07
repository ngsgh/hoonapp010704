import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/models/product.dart';
import '../widgets/product_list_item.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../../../product_register/presentation/pages/product_register_page.dart';

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

          return Column(
            children: [
              // 카테고리 선택 영역
              Container(
                color: AppColors.white,
                padding: const EdgeInsets.all(AppSpacing.medium),
                child: InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      builder: (context) =>
                          _buildCategorySheet(context, provider),
                    );
                  },
                  child: Row(
                    children: [
                      Text(
                        provider.selectedCategory,
                        style: AppTypography.title.copyWith(
                          fontSize: 18,
                          color: AppColors.grey900,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.keyboard_arrow_down,
                        color: AppColors.grey900,
                      ),
                    ],
                  ),
                ),
              ),
              // 상품 리스트
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(AppSpacing.medium),
                  itemCount: provider.groupedProducts.length,
                  itemBuilder: (context, categoryIndex) {
                    final category =
                        provider.groupedProducts.keys.toList()[categoryIndex];
                    final products = provider.groupedProducts[category] ?? [];

                    if (products.isEmpty) return const SizedBox.shrink();

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 4,
                            bottom: AppSpacing.small,
                          ),
                          child: Text(
                            category,
                            style: AppTypography.body.copyWith(
                              color: AppColors.grey700,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        ...products.asMap().entries.map((entry) {
                          final index = entry.key;
                          final product = entry.value;
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: index < products.length - 1
                                  ? AppSpacing.medium
                                  : 24,
                            ),
                            child: ProductListItem(
                              product: product,
                              onEdit: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductRegisterPage(
                                      product: product,
                                      index: provider.products.indexOf(product),
                                    ),
                                  ),
                                );
                              },
                              onDelete: () {
                                provider.deleteProduct(
                                    provider.products.indexOf(product));
                              },
                            ),
                          );
                        }).toList(),
                      ],
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCategorySheet(BuildContext context, ProductProvider provider) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.medium,
            horizontal: AppSpacing.medium,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: AppSpacing.medium),
                  decoration: BoxDecoration(
                    color: AppColors.grey300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              ...provider.categories.map((category) {
                final isSelected = category == provider.selectedCategory;
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    category,
                    style: AppTypography.body.copyWith(
                      color: isSelected ? AppColors.primary : AppColors.grey900,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                  onTap: () {
                    provider.setCategory(category);
                    Navigator.pop(context);
                  },
                );
              }).toList(),
              const SizedBox(height: AppSpacing.medium),
            ],
          ),
        ),
      ),
    );
  }
}
