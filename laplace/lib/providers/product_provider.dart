import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/product_model.dart';

class ProductProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Map<String, Product> _products = {};

  Map<String, Product> get products => _products;
  List<Product> get sellerProducts => _products.values
      .where((product) => product.userId == _auth.currentUser?.uid)
      .toList();

  ProductProvider() {
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        _loadProducts();
      } else {
        _products.clear();
        notifyListeners();
      }
    });
  }

  void _loadProducts() {
    try {
      debugPrint('Loading products...');
      _firestore.collection('products').snapshots().listen(
        (snapshot) {
          debugPrint('Received snapshot with ${snapshot.docChanges.length} changes');
          for (var change in snapshot.docChanges) {
            debugPrint('Processing ${change.type} change for document ${change.doc.id}');
            final data = change.doc.data() as Map<String, dynamic>;
            debugPrint('Document data: $data');
            
            final product = Product.fromMap({
              'id': change.doc.id,
              ...data
            });

            switch (change.type) {
              case DocumentChangeType.added:
              case DocumentChangeType.modified:
                _products[product.id] = product;
                debugPrint('Added/Modified product: ${product.name} in category ${product.category}');
                break;
              case DocumentChangeType.removed:
                _products.remove(product.id);
                debugPrint('Removed product: ${product.id}');
                break;
            }
          }
          debugPrint('Total products after update: ${_products.length}');
          notifyListeners();
        },
        onError: (error) {
          debugPrint('Error loading products: $error');
        },
      );
    } catch (e) {
      debugPrint('Error in _loadProducts: $e');
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      if (_auth.currentUser == null) {
        throw 'User must be authenticated to add products';
      }
      
      await _firestore.collection('products').doc(product.id).set({
        ...product.toMap(),
        'userId': _auth.currentUser!.uid,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Error adding product: $e');
      rethrow;
    }
  }

  Future<void> updateProduct(Product product) async {
    try {
      if (_auth.currentUser == null) {
        throw 'User must be authenticated to update products';
      }
      
      final existingProduct = _products[product.id];
      if (existingProduct?.userId != _auth.currentUser!.uid) {
        throw 'You can only update your own products';
      }
      
      await _firestore.collection('products').doc(product.id).update(product.toMap());
    } catch (e) {
      debugPrint('Error updating product: $e');
      rethrow;
    }
  }

  Future<void> removeProduct(String productId) async {
    try {
      if (_auth.currentUser == null) {
        throw 'User must be authenticated to remove products';
      }
      
      final product = _products[productId];
      if (product?.userId != _auth.currentUser!.uid) {
        throw 'You can only remove your own products';
      }
      
      await _firestore.collection('products').doc(productId).delete();
    } catch (e) {
      debugPrint('Error removing product: $e');
      rethrow;
    }
  }

  Product? getProductById(String productId) {
    return _products[productId];
  }

  List<Product> getProductsByCategory(String category) {
    debugPrint('Getting products for category: $category');
    final categoryProducts = _products.values
        .where((product) => product.category == category)
        .toList();
    debugPrint('Found ${categoryProducts.length} products in category $category');
    return categoryProducts;
  }

  List<Product> searchProducts(String query) {
    final lowercaseQuery = query.toLowerCase();
    return _products.values
        .where((product) =>
            product.name.toLowerCase().contains(lowercaseQuery) ||
            product.description.toLowerCase().contains(lowercaseQuery))
        .toList();
  }
} 