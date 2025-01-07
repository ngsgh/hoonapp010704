import 'package:hive/hive.dart';
import '../../../../core/utils/image_storage_util.dart';

part 'product.g.dart'; // 자동 생성될 파일

@HiveType(typeId: 0)
class Product extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String category;

  @HiveField(2)
  final String location;

  @HiveField(3)
  final DateTime expiryDate;

  @HiveField(4)
  final String? imageUrl;

  Product({
    required this.name,
    required this.category,
    required this.location,
    required this.expiryDate,
    this.imageUrl,
  });

  // 이미지 경로를 상대 경로로 변환하는 팩토리 생성자
  factory Product.create({
    required String name,
    required String category,
    required String location,
    required DateTime expiryDate,
    String? imageUrl,
  }) {
    // 이미지 URL이 있는 경우 상대 경로로 변환
    final relativePath =
        imageUrl != null ? ImageStorageUtil.getRelativePath(imageUrl) : null;

    return Product(
      name: name,
      category: category,
      location: location,
      expiryDate: expiryDate,
      imageUrl: relativePath,
    );
  }
}
