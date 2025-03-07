import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageBase64;
  final String category;
  final String userId;
  final String storeName;
  final DateTime? createdAt;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageBase64,
    required this.category,
    required this.userId,
    required this.storeName,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageBase64': imageBase64,
      'category': category,
      'userId': userId,
      'storeName': storeName,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      imageBase64: map['imageBase64'] ?? '',
      category: map['category'] ?? '',
      userId: map['userId'] ?? '',
      storeName: map['storeName'] ?? '',
      createdAt: map['createdAt'] != null 
          ? (map['createdAt'] as Timestamp).toDate()
          : null,
    );
  }

  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? imageBase64,
    String? category,
    String? userId,
    String? storeName,
    DateTime? createdAt,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageBase64: imageBase64 ?? this.imageBase64,
      category: category ?? this.category,
      userId: userId ?? this.userId,
      storeName: storeName ?? this.storeName,
      createdAt: createdAt ?? this.createdAt,
    );
  }
} 