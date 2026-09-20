import '../entities/order_entity.dart';
import '../repositories/order_repository.dart';

class WatchOrderUseCase {
  const WatchOrderUseCase(this._repository);

  final OrderRepository _repository;

  Stream<OrderEntity?> call(String orderId) {
    return _repository.watchOrder(orderId);
  }
}
