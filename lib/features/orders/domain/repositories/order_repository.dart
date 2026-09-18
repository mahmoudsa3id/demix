import 'package:cloud_firestore/cloud_firestore.dart';
import '../entities/order_entity.dart';

abstract class OrderRepository {
  Future<String> createOrder(OrderEntity order);
  Stream<DocumentSnapshot<Map<String, dynamic>>> watchOrder(String orderId);
  Future<List<DocumentSnapshot<Map<String, dynamic>>>> getMyOrders(
    String userId,
  );
}
