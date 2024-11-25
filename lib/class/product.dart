// lib/models/product.dart

class Product {
  final int id;
  final String title;
  bool? isApproved;

  Product({required this.id, required this.title, this.isApproved});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      isApproved: null, // Estado inicial como null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'isApproved': isApproved != null ? (isApproved! ? 1 : 0) : null,
    };
  }
}
