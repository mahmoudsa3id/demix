import '../entities/order_entity.dart';
import '../repositories/order_repository.dart';

class CreateOrderUseCase {
  const CreateOrderUseCase(this._repository);
  final OrderRepository _repository;
  Future<String> call(OrderEntity order) => _repository.createOrder(order);
}
