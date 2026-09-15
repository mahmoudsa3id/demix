import 'package:demix/features/cart/domain/entities/cart_snapshot.dart';
import 'package:demix/features/cart/domain/repositories/cart_repository.dart';
class GetCartUseCase { const GetCartUseCase(this._repository); final CartRepository _repository; Future<CartSnapshot> call() => _repository.getSnapshot(); }
