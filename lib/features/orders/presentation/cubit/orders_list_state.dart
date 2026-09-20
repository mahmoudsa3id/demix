import 'package:demix/features/orders/domain/entities/order_entity.dart';

sealed class OrdersListState {
  const OrdersListState();
}

class OrdersListInitial extends OrdersListState {
  const OrdersListInitial();
}

class OrdersListLoading extends OrdersListState {
  const OrdersListLoading();
}

class OrdersListLoaded extends OrdersListState {
  const OrdersListLoaded(this.orders);

  final List<OrderEntity> orders;
}

class OrdersListEmpty extends OrdersListState {
  const OrdersListEmpty();
}

class OrdersListFailure extends OrdersListState {
  const OrdersListFailure(this.message);

  final String message;
}
