import 'package:hive/hive.dart';

part 'product_master.g.dart';

@HiveType(typeId: 2)
class ProductMaster extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String category;

  @HiveField(2)
  final String? imageUrl;

  @HiveField(3)
  final int useCount; // 사용 빈도 추적

  @HiveField(4)
  final DateTime createdAt; // 생성 시간

  @HiveField(5)
  final String? purchaseUrl; // 구매 URL

  @HiveField(6)
  final String? storeName; // 구매처 이름

  ProductMaster({
    required this.name,
    required this.category,
    this.imageUrl,
    this.useCount = 0,
    this.purchaseUrl,
    this.storeName,
    DateTime? createdAt,
  }) : this.createdAt = createdAt ?? DateTime.now();

  ProductMaster copyWith({
    String? name,
    String? category,
    String? imageUrl,
    int? useCount,
    DateTime? createdAt,
    String? purchaseUrl,
    String? storeName,
  }) {
    return ProductMaster(
      name: name ?? this.name,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      useCount: useCount ?? this.useCount,
      createdAt: createdAt ?? this.createdAt,
      purchaseUrl: purchaseUrl ?? this.purchaseUrl,
      storeName: storeName ?? this.storeName,
    );
  }
}
