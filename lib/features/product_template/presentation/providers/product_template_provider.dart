import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../domain/models/product_template.dart';
import '../../../home/domain/models/product.dart';

class ProductTemplateProvider extends ChangeNotifier {
  final Box<ProductTemplate> _box;

  ProductTemplateProvider(this._box);

  List<ProductTemplate> get templates => _box.values.toList();

  List<ProductTemplate> getTemplatesByCategory(String category) {
    if (category == '전체') {
      return templates;
    }
    return templates
        .where((template) => template.category == category)
        .toList();
  }

  Future<void> addTemplate(ProductTemplate template) async {
    await _box.add(template);
    notifyListeners();
  }

  Future<void> updateTemplate(int index, ProductTemplate template) async {
    await _box.putAt(index, template);
    notifyListeners();
  }

  Future<void> deleteTemplate(int index) async {
    await _box.deleteAt(index);
    notifyListeners();
  }

  Future<void> incrementUseCount(int index) async {
    final template = _box.getAt(index);
    if (template != null) {
      await _box.putAt(
        index,
        template.copyWith(useCount: template.useCount + 1),
      );
      notifyListeners();
    }
  }

  Product createProductFromTemplate(ProductTemplate template) {
    return Product(
      name: template.name,
      category: template.category,
      location: '', // 보관 위치는 사용자가 입력
      expiryDate: DateTime.now(), // 유통기한은 사용자가 입력
      imageUrl: template.imageUrl,
    );
  }

  List<ProductTemplate> getMostUsedTemplates({int limit = 5}) {
    return templates
      ..sort((a, b) => b.useCount.compareTo(a.useCount))
      ..take(limit).toList();
  }

  List<ProductTemplate> getRecentTemplates({int limit = 5}) {
    return templates
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt))
      ..take(limit).toList();
  }
}
