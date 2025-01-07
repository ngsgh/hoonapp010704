import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/models/product.dart';
import '../widgets/product_list_item.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../../../product_register/presentation/pages/product_register_page.dart';
import '../../../search/presentation/pages/search_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _showSortDialog(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          '정렬',
          style: AppTypography.title.copyWith(
            color: AppColors.grey900,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('유통기한 순'),
              leading: Radio<SortType>(
                value: SortType.expiryDate,
                groupValue: provider.sortType,
                onChanged: (SortType? value) {
                  provider.setSortType(value!);
                  Navigator.pop(context);
                },
              ),
            ),
            ListTile(
              title: const Text('등록일 순'),
              leading: Radio<SortType>(
                value: SortType.registrationDate,
                groupValue: provider.sortType,
                onChanged: (SortType? value) {
                  provider.setSortType(value!);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Consumer<ProductProvider>(
          builder: (context, provider, child) {
            return TextButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  builder: (context) => _buildCategorySheet(context, provider),
                );
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    provider.selectedCategory,
                    style: AppTypography.title.copyWith(
                      color: AppColors.grey900,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.keyboard_arrow_down,
                    color: AppColors.grey900,
                  ),
                ],
              ),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.search,
              color: AppColors.primary,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchPage(),
                ),
              );
            },
          ),
          const SizedBox(width: AppSpacing.small),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showSortDialog(context),
        backgroundColor: AppColors.primary,
        child: const Icon(
          Icons.sort,
          color: Colors.white,
        ),
      ),
      body: Consumer<ProductProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              // 상품 리스트 또는 빈 상태 메시지
              Expanded(
                child: provider.products.isEmpty
                    ? const Center(
                        child: Text('등록된 상품이 없습니다'),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(AppSpacing.medium),
                        itemCount: provider.groupedProducts.length,
                        itemBuilder: (context, categoryIndex) {
                          final category = provider.groupedProducts.keys
                              .toList()[categoryIndex];
                          final products =
                              provider.groupedProducts[category] ?? [];

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
                                          builder: (context) =>
                                              ProductRegisterPage(
                                            product: product,
                                            index: provider.products
                                                .indexOf(product),
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
