import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/models/product.dart';
import '../../../../core/utils/image_storage_util.dart';
import 'dart:io';

class ProductProvider extends ChangeNotifier {
  final Box<Product> _box = Hive.box<Product>('products');

  List<Product> get products => _box.values.toList();

  String _selectedCategory = '전체';
  String get selectedCategory => _selectedCategory;

  List<String> get categories => [
        '전체',
        '유제품',
        '육류',
        '해산물',
        '과일',
        '채소',
        '음료',
        '간식',
        '기타',
      ];

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    try {
      final productToSave = Product(
        name: product.name,
        category: product.category,
        location: product.location,
        expiryDate: product.expiryDate,
        imageUrl: product.imageUrl,
      );

      await _box.add(productToSave);
      notifyListeners();
    } catch (e) {
      debugPrint('상품 저장 오류: $e');
      rethrow;
    }
  }

  Future<void> updateProduct(int index, Product product) async {
    try {
      final productToSave = Product(
        name: product.name,
        category: product.category,
        location: product.location,
        expiryDate: product.expiryDate,
        imageUrl: product.imageUrl,
      );

      await _box.putAt(index, productToSave);
      notifyListeners();
    } catch (e) {
      debugPrint('상품 수정 오류: $e');
      rethrow;
    }
  }

  Future<void> deleteProduct(int index) async {
    final product = _box.getAt(index);
    if (product?.imageUrl != null) {
      await ImageStorageUtil.deleteImage(product!.imageUrl);
    }
    await _box.deleteAt(index);
    notifyListeners();
  }

  Map<String, List<Product>> get groupedProducts {
    final grouped = <String, List<Product>>{};
    final filteredProducts = _selectedCategory == '전체'
        ? products
        : products.where((p) => p.category == _selectedCategory).toList();

    for (final product in filteredProducts) {
      if (!grouped.containsKey(product.category)) {
        grouped[product.category] = [];
      }
      grouped[product.category]!.add(product);
    }

    return grouped;
  }
}
