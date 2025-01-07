class Product {
  final String name;
  final String category;
  final String location;
  final DateTime expiryDate;
  final String? imageUrl;

  Product({
    required this.name,
    required this.category,
    required this.location,
    required this.expiryDate,
    this.imageUrl,
  });
}
