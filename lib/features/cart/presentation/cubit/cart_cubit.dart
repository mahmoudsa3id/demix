import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:demix/features/business/domain/entities/business.dart';
import 'package:demix/features/business/domain/entities/product.dart';
import 'package:demix/features/cart/domain/entities/cart_item.dart';
import 'package:demix/features/cart/domain/use_cases/clear_cart_use_case.dart';
import 'package:demix/features/cart/domain/use_cases/delete_cart_item_use_case.dart';
import 'package:demix/features/cart/domain/use_cases/get_cart_use_case.dart';
import 'package:demix/features/cart/domain/use_cases/save_cart_item_use_case.dart';

class CartState {
  const CartState({this.items = const [], this.business, this.isLoading = false});
  final List<CartItem> items;
  final Business? business;
  final bool isLoading;

  double get subtotal => items.fold(0, (sum, item) => sum + item.lineTotal);
  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  CartState copyWith({List<CartItem>? items, Business? business, bool? isLoading}) =>
      CartState(items: items ?? this.items, business: business ?? this.business, isLoading: isLoading ?? this.isLoading);
}

class CartCubit extends Cubit<CartState> {
  CartCubit({
    required GetCartUseCase getCart,
    required SaveCartItemUseCase saveCartItem,
    required DeleteCartItemUseCase deleteCartItem,
    required ClearCartUseCase clearCart,
  })  : _getCart = getCart,
        _saveCartItem = saveCartItem,
        _deleteCartItem = deleteCartItem,
        _clearCart = clearCart,
        super(const CartState());

  final GetCartUseCase _getCart;
  final SaveCartItemUseCase _saveCartItem;
  final DeleteCartItemUseCase _deleteCartItem;
  final ClearCartUseCase _clearCart;

  Future<void> load() async {
    emit(CartState(items: state.items, business: state.business, isLoading: true));
    try {
      final snapshot = await _getCart();
      emit(CartState(items: snapshot.items, business: snapshot.business));
    } catch (_) {
      emit(CartState(items: state.items, business: state.business));
    }
  }

  Future<void> addItem({
    required Product product,
    required Business business,
    int quantity = 1,
  }) async {
    if (quantity <= 0) return;
    if (state.business != null && state.business!.id != business.id) {
      throw StateError('لا يمكن إضافة منتجات من مطعم آخر. أفرغ السلة أولاً.');
    }

    final items = [...state.items];
    final index = items.indexWhere((item) => item.product.id == product.id);
    final item = index == -1
        ? CartItem(product: product, quantity: quantity)
        : items[index].copyWith(quantity: items[index].quantity + quantity);

    if (index == -1) {
      items.add(item);
    } else {
      items[index] = item;
    }

    await _saveCartItem(item, business);
    emit(CartState(items: items, business: business));
  }

  Future<void> increase(String productId) async {
    final index = state.items.indexWhere((item) => item.product.id == productId);
    if (index == -1) return;
    final item = state.items[index].copyWith(quantity: state.items[index].quantity + 1);
    final items = [...state.items]..[index] = item;
    if (state.business != null) await _saveCartItem(item, state.business!);
    emit(CartState(items: items, business: state.business));
  }

  Future<void> decrease(String productId) async {
    final index = state.items.indexWhere((item) => item.product.id == productId);
    if (index == -1) return;
    final current = state.items[index];
    if (current.quantity <= 1) {
      return remove(productId);
    }
    final item = current.copyWith(quantity: current.quantity - 1);
    final items = [...state.items]..[index] = item;
    if (state.business != null) await _saveCartItem(item, state.business!);
    emit(CartState(items: items, business: state.business));
  }

  Future<void> remove(String productId) async {
    final items = state.items.where((item) => item.product.id != productId).toList();
    await _deleteCartItem(productId);
    emit(CartState(items: items, business: items.isEmpty ? null : state.business));
  }

  Future<void> clear() async {
    await _clearCart();
    emit(const CartState());
  }
}
