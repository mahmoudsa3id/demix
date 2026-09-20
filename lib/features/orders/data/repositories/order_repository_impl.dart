import 'package:demix/features/orders/data/datasources/models/order_models.dart';
import 'package:demix/features/orders/data/datasources/order_remote_data_source.dart';
import 'package:demix/features/orders/domain/entities/order_entity.dart';
import 'package:demix/features/orders/domain/repositories/order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  OrderRepositoryImpl({required OrderRemoteDataSource remote})
    : _remote = remote;

  final OrderRemoteDataSource _remote;

  @override
  Future<String> createOrder(OrderEntity order) {
    return _remote.createOrder(order);
  }

  @override
  Stream<OrderEntity?> watchOrder(String orderId) {
    return _remote.watchOrder(orderId).map((snapshot) {
      if (!snapshot.exists) {
        return null;
      }

      return OrderModel.fromFirebase(snapshot.data() ?? {}, id: snapshot.id);
    });
  }

  @override
  Future<List<OrderEntity>> getMyOrders(String userId) async {
    final snapshots = await _remote.getMyOrders(userId);

    return snapshots
        .map(
          (snapshot) =>
              OrderModel.fromFirebase(snapshot.data() ?? {}, id: snapshot.id),
        )
        .toList();
  }
}
