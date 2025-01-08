import 'package:flutter/material.dart';
import 'package:hoonapp010704/core/services/naver_shopping_service.dart';

class ProductRegisterProvider extends ChangeNotifier {
  final NaverShoppingService _naverShoppingService = NaverShoppingService();

  Future<Map<String, dynamic>?> searchProduct(String query) async {
    try {
      return await _naverShoppingService.searchByName(query);
    } catch (e) {
      print('상품 검색 오류: $e');
      return null;
    }
  }
}
