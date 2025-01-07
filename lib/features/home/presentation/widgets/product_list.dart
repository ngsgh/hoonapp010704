import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/providers/product_provider.dart';
import 'product_list_item.dart';

class ProductList extends StatelessWidget {
  const ProductList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, provider, child) {
        final products = provider.products;

        if (products.isEmpty) {
          return const Center(
            child: Text('등록된 상품이 없습니다'),
          );
        }

        return ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return ProductListItem(
              product: product,
              onTap: () {
                // 상품 상세 페이지로 이동
              },
            );
          },
        );
      },
    );
  }
}
