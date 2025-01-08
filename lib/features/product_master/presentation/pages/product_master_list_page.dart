import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/image_storage_util.dart';
import '../../domain/models/product_master.dart';
import '../providers/product_master_provider.dart';
import 'product_master_edit_page.dart';

class ProductMasterListPage extends StatefulWidget {
  const ProductMasterListPage({super.key});

  @override
  State<ProductMasterListPage> createState() => _ProductMasterListPageState();
}

class _ProductMasterListPageState extends State<ProductMasterListPage> {
  final _searchController = TextEditingController();
  String _selectedCategory = '전체';

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
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.grey900,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '상품 마스터 관리',
          style: AppTypography.title.copyWith(
            color: AppColors.grey900,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add,
              color: AppColors.primary,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProductMasterEditPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<ProductMasterProvider>(
        builder: (context, provider, child) {
          final categories = ['전체', ...provider.getCategories()];

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.medium),
                child: Column(
                  children: [
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: '상품명 검색',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  setState(() {
                                    _searchController.clear();
                                  });
                                },
                              )
                            : null,
                      ),
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                    const SizedBox(height: AppSpacing.small),
                    SizedBox(
                      height: 40,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: AppSpacing.small),
                        itemBuilder: (context, index) {
                          final category = categories[index];
                          return FilterChip(
                            label: Text(category),
                            selected: _selectedCategory == category,
                            onSelected: (selected) {
                              setState(() {
                                _selectedCategory = category;
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: FutureBuilder<List<ProductMaster>>(
                  future: provider.searchProducts(_searchController.text),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text('상품이 없습니다.'),
                      );
                    }

                    final products = _selectedCategory == '전체'
                        ? snapshot.data!
                        : snapshot.data!
                            .where((p) => p.category == _selectedCategory)
                            .toList();

                    return ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return ListTile(
                          leading: product.imageUrl != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: product.imageUrl!.startsWith('http')
                                      ? Image.network(
                                          product.imageUrl!,
                                          width: 40,
                                          height: 40,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Container(
                                              width: 40,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                color: AppColors.grey300,
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              child: const Icon(
                                                Icons
                                                    .image_not_supported_outlined,
                                                color: AppColors.grey500,
                                                size: 24,
                                              ),
                                            );
                                          },
                                        )
                                      : Image.file(
                                          File(product.imageUrl!),
                                          width: 40,
                                          height: 40,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            print('이미지 로드 에러: $error');
                                            print(
                                                '시도한 경로: ${product.imageUrl}');
                                            return Container(
                                              width: 40,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                color: AppColors.grey300,
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              child: const Icon(
                                                Icons
                                                    .image_not_supported_outlined,
                                                color: AppColors.grey500,
                                                size: 24,
                                              ),
                                            );
                                          },
                                        ),
                                )
                              : Container(
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
                          title: Text(product.name),
                          subtitle: Text(product.category),
                          trailing: Text(
                            '사용 ${product.useCount}회',
                            style: AppTypography.body.copyWith(
                              color: AppColors.grey700,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductMasterEditPage(
                                  product: product,
                                ),
                              ),
                            );
                          },
                        );
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
}
