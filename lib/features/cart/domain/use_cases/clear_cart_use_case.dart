import 'package:demix/features/cart/domain/repositories/cart_repository.dart';

class ClearCartUseCase {
  const ClearCartUseCase(this._repository);
  final CartRepository _repository;
  Future<void> call() => _repository.clear();
}
