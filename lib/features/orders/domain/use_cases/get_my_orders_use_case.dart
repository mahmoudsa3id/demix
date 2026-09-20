import '../entities/order_entity.dart';
import '../repositories/order_repository.dart';

class GetMyOrdersUseCase {
  const GetMyOrdersUseCase(this._repository);

  final OrderRepository _repository;

  Future<List<OrderEntity>> call(String userId) {
    return _repository.getMyOrders(userId);
  }
}
