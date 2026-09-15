import 'package:demix/features/cart/domain/repositories/cart_repository.dart';

class DeleteCartItemUseCase {
  const DeleteCartItemUseCase(this._repository);
  final CartRepository _repository;
  Future<void> call(String productId) => _repository.deleteItem(productId);
}
