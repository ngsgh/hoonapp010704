import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/models/product.dart';
import '../../../../core/utils/image_storage_util.dart';
import 'dart:io';

enum SortType {
  none,
  expiryDate,
  registrationDate,
}

class ProductProvider extends ChangeNotifier {
  final Box<Product> _box;

  ProductProvider(this._box);

  SortType _sortType = SortType.none;

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

  SortType get sortType => _sortType;

  void setSortType(SortType type) {
    _sortType = type;
    notifyListeners();
  }

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

    for (var product in filteredProducts) {
      grouped.putIfAbsent(product.category, () => []).add(product);
    }

    // 각 카테고리 내에서 정렬
    grouped.forEach((category, products) {
      switch (_sortType) {
        case SortType.expiryDate:
          products.sort((a, b) => a.expiryDate.compareTo(b.expiryDate));
          break;
        case SortType.registrationDate:
          // Hive의 key를 기준으로 정렬 (등록 순서)
          products.sort((a, b) => (a.key as int).compareTo(b.key as int));
          break;
        case SortType.none:
          // 기본 정렬 (등록 순서)
          products.sort((a, b) => (a.key as int).compareTo(b.key as int));
          break;
      }
    });

    return grouped;
  }
}
