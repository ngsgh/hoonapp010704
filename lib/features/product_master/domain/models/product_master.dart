import 'package:hive/hive.dart';

part 'product_master.g.dart';

@HiveType(typeId: 3)
class ProductMaster extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String category;

  @HiveField(2)
  final String? imageUrl;

  @HiveField(3)
  final int useCount;

  @HiveField(4)
  final DateTime createdAt;

  @HiveField(5)
  final String? storeName;

  @HiveField(6)
  final String? purchaseUrl;

  ProductMaster({
    required this.name,
    required this.category,
    this.imageUrl,
    this.useCount = 0,
    DateTime? createdAt,
    this.storeName,
    this.purchaseUrl,
  }) : createdAt = createdAt ?? DateTime.now();

  ProductMaster copyWith({
    String? name,
    String? category,
    String? imageUrl,
    int? useCount,
    DateTime? createdAt,
    String? storeName,
    String? purchaseUrl,
  }) {
    return ProductMaster(
      name: name ?? this.name,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      useCount: useCount ?? this.useCount,
      createdAt: createdAt ?? this.createdAt,
      storeName: storeName ?? this.storeName,
      purchaseUrl: purchaseUrl ?? this.purchaseUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'category': category,
      'imageUrl': imageUrl,
      'useCount': useCount,
      'storeName': storeName,
      'purchaseUrl': purchaseUrl,
    };
  }

  factory ProductMaster.fromJson(Map<String, dynamic> json) {
    return ProductMaster(
      name: json['name'] as String,
      category: json['category'] as String,
      imageUrl: json['imageUrl'] as String?,
      useCount: json['useCount'] as int,
      storeName: json['storeName'] as String?,
      purchaseUrl: json['purchaseUrl'] as String?,
    );
  }
}
