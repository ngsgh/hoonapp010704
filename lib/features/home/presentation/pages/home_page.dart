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
          return Column(
            children: [
              // 카테고리 선택 영역
              Container(
                color: AppColors.white,
                padding: const EdgeInsets.all(AppSpacing.medium),
                child: Row(
                  children: [
                    InkWell(
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
                  ],
                ),
              ),
              // 상품 리스트
              Expanded(
                child: provider.products.isEmpty
                    ? const Center(
                        child: Text('등록된 상품이 없습니다'),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(AppSpacing.medium),
                        itemCount: provider.products.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: AppSpacing.medium),
                        itemBuilder: (context, index) {
                          final product = provider.products[index];
                          return ProductListItem(
                            product: product,
                            onEdit: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductRegisterPage(
                                    product: product,
                                    index: index,
                                  ),
                                ),
                              );
                            },
                            onDelete: () {
                              provider.deleteProduct(index);
                            },
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
              // 상단 드래그 핸들
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
              // 하단 여백
              const SizedBox(height: AppSpacing.medium),
            ],
          ),
        ),
      ),
    );
  }
}
