import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/cart_item_model.dart';

class CartItem {
  final String id;
  final String name;
  final double price;
  final int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    this.quantity = 1,
  });

  CartItem copyWith({
    String? id,
    String? name,
    double? price,
    int? quantity,
  }) {
    return CartItem(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
    );
  }
}

class CartProvider with ChangeNotifier {
  final Box<CartItemModel> _box = Hive.box<CartItemModel>('cart');
  final Map<String, CartItem> _items = {};

  CartProvider() {
    _loadItems();
  }

  void _loadItems() {
    for (var model in _box.values) {
      final item = model.toCartItem();
      _items[item.id] = item;
    }
    notifyListeners();
  }

  void _saveItems() {
    _box.clear();
    for (var item in _items.values) {
      _box.add(CartItemModel.fromCartItem(item));
    }
  }

  Map<String, CartItem> get items => {..._items};

  int get itemCount => _items.length;

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addItem({
    required String productId,
    required String name,
    required double price,
  }) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (existingCartItem) => existingCartItem.copyWith(
          quantity: existingCartItem.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: productId,
          name: name,
          price: price,
        ),
      );
    }
    _saveItems();
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    _saveItems();
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId]!.quantity > 1) {
      _items.update(
        productId,
        (existingCartItem) => existingCartItem.copyWith(
          quantity: existingCartItem.quantity - 1,
        ),
      );
    } else {
      _items.remove(productId);
    }
    _saveItems();
    notifyListeners();
  }

  void clear() {
    _items.clear();
    _saveItems();
    notifyListeners();
  }
} 