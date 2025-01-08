import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../../domain/models/product_master.dart';

class ProductMasterProvider extends ChangeNotifier {
  final Box<ProductMaster> _box;

  ProductMasterProvider(this._box);

  List<String> get categories => [
        '유제품',
        '음료',
        '과일',
        '채소',
        '육류',
        '해산물',
        '가공식품',
        '조미료',
        '기타',
      ];

  List<ProductMaster> searchProducts(String query) {
    if (query.isEmpty) {
      return _box.values.toList();
    }
    return _box.values
        .where((product) =>
            product.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  List<String> getCategories() {
    return categories;
  }

  Future<void> addProduct(ProductMaster product) async {
    await _box.add(product);
    notifyListeners();
  }

  Future<void> updateProduct(
      ProductMaster oldProduct, ProductMaster newProduct) async {
    final index = _box.values.toList().indexOf(oldProduct);
    if (index != -1) {
      await _box.putAt(index, newProduct);
      notifyListeners();
    }
  }

  Future<void> deleteProduct(ProductMaster product) async {
    final index = _box.values.toList().indexOf(product);
    if (index != -1) {
      await _box.deleteAt(index);
      notifyListeners();
    }
  }

  Future<void> incrementUseCount(ProductMaster product) async {
    final index = _box.values.toList().indexOf(product);
    if (index != -1) {
      final updatedProduct = product.copyWith(
        useCount: product.useCount + 1,
      );
      await _box.putAt(index, updatedProduct);
      notifyListeners();
    }
  }
}
