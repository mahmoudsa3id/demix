import 'package:demix/features/business/domain/entities/business.dart';
import 'package:demix/features/cart/domain/entities/cart_item.dart';
import 'package:demix/features/cart/domain/repositories/cart_repository.dart';
class SaveCartItemUseCase { const SaveCartItemUseCase(this._repository); final CartRepository _repository; Future<void> call(CartItem item, Business business) => _repository.saveItem(item, business); }
