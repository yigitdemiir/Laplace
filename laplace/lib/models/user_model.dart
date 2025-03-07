import 'package:cloud_firestore/cloud_firestore.dart';

enum UserRole {
  customer,
  seller,
}

class UserModel {
  final String id;
  final String email;
  final String? displayName;
  final String? photoURL;
  final UserRole role;
  final DateTime createdAt;
  final String? phoneNumber;
  final String? storeName; // Only for sellers
  final String? storeDescription; // Only for sellers

  UserModel({
    required this.id,
    required this.email,
    this.displayName,
    this.photoURL,
    required this.role,
    required this.createdAt,
    this.phoneNumber,
    this.storeName,
    this.storeDescription,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'role': role.toString().split('.').last,
      'createdAt': createdAt,
      'phoneNumber': phoneNumber,
      'storeName': storeName,
      'storeDescription': storeDescription,
    };
  }

  factory UserModel.fromMap(String id, Map<String, dynamic> map) {
    return UserModel(
      id: id,
      email: map['email'] ?? '',
      displayName: map['displayName'],
      photoURL: map['photoURL'],
      role: UserRole.values.firstWhere(
        (role) => role.toString().split('.').last == map['role'],
        orElse: () => UserRole.customer,
      ),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      phoneNumber: map['phoneNumber'],
      storeName: map['storeName'],
      storeDescription: map['storeDescription'],
    );
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? displayName,
    String? photoURL,
    UserRole? role,
    DateTime? createdAt,
    String? phoneNumber,
    String? storeName,
    String? storeDescription,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      storeName: storeName ?? this.storeName,
      storeDescription: storeDescription ?? this.storeDescription,
    );
  }
} 