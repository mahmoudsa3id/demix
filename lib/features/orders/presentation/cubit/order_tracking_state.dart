import 'package:demix/features/orders/domain/entities/order_entity.dart';

sealed class OrderTrackingState {
  const OrderTrackingState();
}

class OrderTrackingInitial extends OrderTrackingState {
  const OrderTrackingInitial();
}

class OrderTrackingLoading extends OrderTrackingState {
  const OrderTrackingLoading();
}

class OrderTrackingLoaded extends OrderTrackingState {
  const OrderTrackingLoaded(this.order);

  final OrderEntity order;
}

class OrderTrackingFailure extends OrderTrackingState {
  const OrderTrackingFailure(this.message);

  final String message;
}
