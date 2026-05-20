// lib/models/product.dart
class Product {
  final String id;
  final String title;
  final double price;
  final String imageUrl;
  final String category;
  final String description;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.description,
    this.isFavorite = false,
  });

  factory Product.fromFirestore(Map<String, dynamic> data, String id) {
    return Product(
      id: id,
      title: data['title'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      imageUrl: data['imageUrl'] ?? '',
      category: data['category'] ?? '',
      description: data['description'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'price': price,
      'imageUrl': imageUrl,
      'category': category,
      'description': description,
    };
  }
}
