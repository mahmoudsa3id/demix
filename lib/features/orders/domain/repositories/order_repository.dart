import '../entities/order_entity.dart';

abstract class OrderRepository {
  Future<String> createOrder(OrderEntity order);

  Stream<OrderEntity?> watchOrder(String orderId);

  Future<List<OrderEntity>> getMyOrders(String userId);
}
