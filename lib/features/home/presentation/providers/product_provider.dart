import 'package:flutter/material.dart';
import '../../domain/models/product.dart';

class ProductProvider extends ChangeNotifier {
  final List<Product> _products = [];
  String _selectedCategory = '전체'; // 선택된 카테고리

  List<Product> get products {
    if (_selectedCategory == '전체') {
      return _products;
    }
    return _products
        .where((product) => product.category == _selectedCategory)
        .toList();
  }

  String get selectedCategory => _selectedCategory;

  // 카테고리 목록
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

  void addProduct(Product product) {
    _products.add(product);
    notifyListeners();
  }

  void updateProduct(int index, Product product) {
    _products[index] = product;
    notifyListeners();
  }

  void deleteProduct(int index) {
    _products.removeAt(index);
    notifyListeners();
  }
}
