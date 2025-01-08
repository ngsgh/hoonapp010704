import 'package:hive/hive.dart';
import '../../../../core/utils/image_storage_util.dart';
import '../../../product_master/domain/models/product_master.dart';

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

  @HiveField(5)
  final String? masterId; // 마스터 상품 ID

  @HiveField(6)
  final String? purchaseUrl; // 구매 URL

  @HiveField(7)
  final String? storeName; // 구매처 이름

  Product({
    required this.name,
    required this.category,
    required this.location,
    required this.expiryDate,
    this.imageUrl,
    this.masterId,
    this.purchaseUrl,
    this.storeName,
  });

  // 이미지 경로를 상대 경로로 변환하는 팩토리 생성자
  factory Product.create({
    required String name,
    required String category,
    required String location,
    required DateTime expiryDate,
    String? imageUrl,
    String? masterId,
    String? purchaseUrl,
    String? storeName,
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
      masterId: masterId,
      purchaseUrl: purchaseUrl,
      storeName: storeName,
    );
  }

  // 마스터 상품으로부터 생성하는 팩토리 생성자
  factory Product.fromMaster({
    required ProductMaster master,
    required String location,
    required DateTime expiryDate,
  }) {
    return Product(
      name: master.name,
      category: master.category,
      location: location,
      expiryDate: expiryDate,
      imageUrl: master.imageUrl,
      masterId: master.key?.toString(),
      purchaseUrl: master.purchaseUrl,
      storeName: master.storeName,
    );
  }
}
