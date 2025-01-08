import 'package:hive/hive.dart';
import '../../../../core/utils/image_storage_util.dart';

part 'product.g.dart';

@HiveType(typeId: 1)
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
  final String? masterId;

  @HiveField(6)
  final String? storeName;

  @HiveField(7)
  final String? purchaseUrl;

  Product({
    required this.name,
    required this.category,
    required this.location,
    required this.expiryDate,
    this.imageUrl,
    this.masterId,
    this.storeName,
    this.purchaseUrl,
  });

  Product copyWith({
    String? name,
    String? category,
    String? location,
    DateTime? expiryDate,
    String? imageUrl,
    String? masterId,
    String? storeName,
    String? purchaseUrl,
  }) {
    return Product(
      name: name ?? this.name,
      category: category ?? this.category,
      location: location ?? this.location,
      expiryDate: expiryDate ?? this.expiryDate,
      imageUrl: imageUrl ?? this.imageUrl,
      masterId: masterId ?? this.masterId,
      storeName: storeName ?? this.storeName,
      purchaseUrl: purchaseUrl ?? this.purchaseUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'category': category,
      'location': location,
      'expiryDate': expiryDate.toIso8601String(),
      'imageUrl': imageUrl,
      'masterId': masterId,
      'storeName': storeName,
      'purchaseUrl': purchaseUrl,
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'] as String,
      category: json['category'] as String,
      location: json['location'] as String,
      expiryDate: DateTime.parse(json['expiryDate'] as String),
      imageUrl: json['imageUrl'] as String?,
      masterId: json['masterId'] as String?,
      storeName: json['storeName'] as String?,
      purchaseUrl: json['purchaseUrl'] as String?,
    );
  }
}
