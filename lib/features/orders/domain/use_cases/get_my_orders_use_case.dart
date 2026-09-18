import 'package:cloud_firestore/cloud_firestore.dart';
import '../repositories/order_repository.dart';

class GetMyOrdersUseCase {
  const GetMyOrdersUseCase(this._repository);
  final OrderRepository _repository;
  Future<List<DocumentSnapshot<Map<String, dynamic>>>> call(String userId) =>
      _repository.getMyOrders(userId);
}
