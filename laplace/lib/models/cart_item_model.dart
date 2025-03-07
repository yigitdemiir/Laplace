import 'package:hive/hive.dart';
import '../providers/cart_provider.dart';

part 'cart_item_model.g.dart';

@HiveType(typeId: 0)
class CartItemModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final double price;

  @HiveField(4)
  final int quantity;

  CartItemModel({
    required this.id,
    required this.name,
    required this.price,
    this.quantity = 1,
  });

  factory CartItemModel.fromCartItem(CartItem item) {
    return CartItemModel(
      id: item.id,
      name: item.name,
      price: item.price,
      quantity: item.quantity,
    );
  }

  CartItem toCartItem() {
    return CartItem(
      id: id,
      name: name,
      price: price,
      quantity: quantity,
    );
  }
} 