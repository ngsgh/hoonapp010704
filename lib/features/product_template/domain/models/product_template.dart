import 'package:hive/hive.dart';

part 'product_template.g.dart';

@HiveType(typeId: 1)
class ProductTemplate extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String category;

  @HiveField(2)
  final String? imageUrl;

  @HiveField(3)
  final DateTime createdAt;

  @HiveField(4)
  final int useCount; // 이 템플릿이 사용된 횟수

  ProductTemplate({
    required this.name,
    required this.category,
    this.imageUrl,
    DateTime? createdAt,
    this.useCount = 0,
  }) : createdAt = createdAt ?? DateTime.now();

  ProductTemplate copyWith({
    String? name,
    String? category,
    String? imageUrl,
    DateTime? createdAt,
    int? useCount,
  }) {
    return ProductTemplate(
      name: name ?? this.name,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      useCount: useCount ?? this.useCount,
    );
  }
}
