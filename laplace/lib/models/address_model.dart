// ignore: unused_import
import 'package:cloud_firestore/cloud_firestore.dart';

class Address {
  final String id;
  final String userId;
  final String fullName;
  final String addressLine;
  final String city;
  final String postalCode;
  final bool isDefault;

  Address({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.addressLine,
    required this.city,
    required this.postalCode,
    this.isDefault = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'fullName': fullName,
      'addressLine': addressLine,
      'city': city,
      'postalCode': postalCode,
      'isDefault': isDefault,
    };
  }

  factory Address.fromMap(String id, Map<String, dynamic> map) {
    return Address(
      id: id,
      userId: map['userId'] ?? '',
      fullName: map['fullName'] ?? '',
      addressLine: map['addressLine'] ?? '',
      city: map['city'] ?? '',
      postalCode: map['postalCode'] ?? '',
      isDefault: map['isDefault'] ?? false,
    );
  }

  Address copyWith({
    String? id,
    String? userId,
    String? fullName,
    String? addressLine,
    String? city,
    String? postalCode,
    bool? isDefault,
  }) {
    return Address(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      addressLine: addressLine ?? this.addressLine,
      city: city ?? this.city,
      postalCode: postalCode ?? this.postalCode,
      isDefault: isDefault ?? this.isDefault,
    );
  }
} 