import 'package:demix/features/business/domain/entities/business.dart';
import 'package:demix/features/cart/data/datasources/cart_local_data_source.dart';
import 'package:demix/features/cart/data/models/cart_item_model.dart';
import 'package:demix/features/cart/domain/entities/cart_item.dart';
import 'package:demix/features/cart/domain/entities/cart_snapshot.dart';
import 'package:demix/features/cart/domain/repositories/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  CartRepositoryImpl({required CartLocalDataSource localDataSource}) : _local = localDataSource;
  final CartLocalDataSource _local;
  @override Future<CartSnapshot> getSnapshot() => _local.getSnapshot();
  @override Future<void> saveItem(CartItem item, Business business) => _local.upsertItem(CartItemModel(product: item.product, quantity: item.quantity), business);
  @override Future<void> deleteItem(String productId) => _local.deleteItem(productId);
  @override Future<void> clear() => _local.clear();
}
