import 'dart:convert';
import 'package:http/http.dart' as http;

class NaverShoppingService {
  static const String _clientId = '_kP211AntFjXuldqk9Pt';
  static const String _clientSecret = 'e7xYNjstOs';
  static const String _apiUrl = 'https://openapi.naver.com/v1/search/shop.json';

  Future<Map<String, dynamic>?> searchByName(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$_apiUrl?query=${Uri.encodeComponent(query)}'),
        headers: {
          'X-Naver-Client-Id': _clientId,
          'X-Naver-Client-Secret': _clientSecret,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['items'] != null && data['items'].isNotEmpty) {
          final item = data['items'][0];
          return {
            'name': item['title'].replaceAll(RegExp(r'<[^>]*>'), ''),
            'imageUrl': item['image'],
            'storeName': item['mallName'],
            'purchaseUrl': item['link'],
          };
        }
      }
      return null;
    } catch (e) {
      print('네이버 쇼핑 API 오류: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> searchByBarcode(String barcode) async {
    try {
      // 바코드로 검색
      var response = await http.get(
        Uri.parse('$_apiUrl?query=$barcode'),
        headers: {
          'X-Naver-Client-Id': _clientId,
          'X-Naver-Client-Secret': _clientSecret,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['items'] != null && data['items'].isNotEmpty) {
          final item = data['items'][0];
          final title = item['title'].replaceAll(RegExp(r'<[^>]*>'), '');

          // 상품명으로 다시 검색
          response = await http.get(
            Uri.parse('$_apiUrl?query=${Uri.encodeComponent(title)}'),
            headers: {
              'X-Naver-Client-Id': _clientId,
              'X-Naver-Client-Secret': _clientSecret,
            },
          );

          if (response.statusCode == 200) {
            final newData = json.decode(response.body);
            if (newData['items'] != null && newData['items'].isNotEmpty) {
              final bestMatch = newData['items'][0];
              return {
                'name': bestMatch['title'].replaceAll(RegExp(r'<[^>]*>'), ''),
                'imageUrl': bestMatch['image'],
                'storeName': bestMatch['mallName'],
                'purchaseUrl': bestMatch['link'],
              };
            }
          }

          // 첫 번째 검색 결과 사용
          return {
            'name': title,
            'imageUrl': item['image'],
            'storeName': item['mallName'],
            'purchaseUrl': item['link'],
          };
        }
      }

      // 검색 실패시 바코드 번호로 반환
      return {
        'name': '상품 $barcode',
        'imageUrl': null,
        'storeName': '',
        'purchaseUrl': '',
      };
    } catch (e) {
      print('네이버 쇼핑 API 오류: $e');
      return null;
    }
  }
}
