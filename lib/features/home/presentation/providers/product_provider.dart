import 'package:flutter/material.dart';
import '../../domain/models/product.dart';

class ProductProvider extends ChangeNotifier {
  final List<Product> _products = [];

  List<Product> get products => _products;

  void addProduct(Product product) {
    _products.add(product);
    notifyListeners();
  }
}