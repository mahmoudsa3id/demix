import 'package:demix/features/business/domain/entities/business.dart';
import 'package:demix/features/cart/domain/entities/cart_item.dart';
import 'package:demix/features/cart/domain/entities/cart_snapshot.dart';

abstract class CartRepository {
  Future<CartSnapshot> getSnapshot();
  Future<void> saveItem(CartItem item, Business business);
  Future<void> deleteItem(String productId);
  Future<void> clear();
}
