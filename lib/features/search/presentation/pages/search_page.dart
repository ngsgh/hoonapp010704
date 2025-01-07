import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../home/presentation/providers/product_provider.dart';
import '../../../home/presentation/widgets/product_list_item.dart';
import '../../../product_register/presentation/pages/product_register_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.grey900,
            size: 24,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '검색',
          style: AppTypography.title.copyWith(
            color: AppColors.grey900,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.medium),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: '검색어를 입력하세요',
                hintStyle: AppTypography.body.copyWith(
                  color: AppColors.grey500,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.primary,
                ),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(
                          Icons.clear,
                          color: AppColors.grey500,
                        ),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                filled: true,
                fillColor: AppColors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.medium,
                  vertical: AppSpacing.small,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: Consumer<ProductProvider>(
              builder: (context, provider, child) {
                final searchResults = provider.products.where((product) =>
                    product.name
                        .toLowerCase()
                        .contains(_searchQuery.toLowerCase()) ||
                    product.category
                        .toLowerCase()
                        .contains(_searchQuery.toLowerCase()) ||
                    product.location
                        .toLowerCase()
                        .contains(_searchQuery.toLowerCase()));

                if (_searchQuery.isEmpty) {
                  return Center(
                    child: Text(
                      '검색어를 입력하세요',
                      style: AppTypography.body.copyWith(
                        color: AppColors.grey700,
                      ),
                    ),
                  );
                }

                if (searchResults.isEmpty) {
                  return Center(
                    child: Text(
                      '검색 결과가 없습니다',
                      style: AppTypography.body.copyWith(
                        color: AppColors.grey700,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(AppSpacing.medium),
                  itemCount: searchResults.length,
                  itemBuilder: (context, index) {
                    final product = searchResults.elementAt(index);
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: index < searchResults.length - 1
                            ? AppSpacing.medium
                            : 0,
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
                          if (searchResults.length == 1) {
                            Navigator.pop(context);
                          }
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
