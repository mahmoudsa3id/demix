import 'package:equatable/equatable.dart';
import 'package:demix/features/business/domain/entities/business.dart';
import 'package:demix/features/cart/domain/entities/cart_item.dart';

class CartSnapshot extends Equatable {
  const CartSnapshot({required this.items, this.business});
  final List<CartItem> items;
  final Business? business;
  @override
  List<Object?> get props => [items, business];
}
