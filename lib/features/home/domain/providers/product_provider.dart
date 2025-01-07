import 'package:flutter/material.dart';
import '../models/product.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ProductProvider with ChangeNotifier {
  final Box<Product> _productBox;

  ProductProvider(this._productBox);

  List<Product> get products => _productBox.values.toList();

  Future<void> addProduct(Product product) async {
    await _productBox.add(product);
    notifyListeners();
  }

  Future<void> updateProduct(int index, Product product) async {
    await _productBox.putAt(index, product);
    notifyListeners();
  }

  Future<void> deleteProduct(int index) async {
    await _productBox.deleteAt(index);
    notifyListeners();
  }
}
