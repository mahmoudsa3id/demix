import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/order_entity.dart';
import '../../domain/use_cases/watch_order_use_case.dart';

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

class OrderTrackingCubit extends Cubit<OrderTrackingState> {
  OrderTrackingCubit({required WatchOrderUseCase watchOrder})
    : _watchOrder = watchOrder,
      super(const OrderTrackingInitial());

  final WatchOrderUseCase _watchOrder;

  StreamSubscription<OrderEntity?>? _sub;

  void watch(String orderId) {
    _sub?.cancel();

    emit(const OrderTrackingLoading());

    _sub = _watchOrder(orderId).listen(
      (order) {
        if (isClosed) return;

        if (order == null) {
          emit(const OrderTrackingFailure('Order not found'));
          return;
        }

        emit(OrderTrackingLoaded(order));
      },
      onError: (error) {
        if (isClosed) return;

        emit(OrderTrackingFailure(error.toString()));
      },
    );
  }

  @override
  Future<void> close() async {
    await _sub?.cancel();
    return super.close();
  }
}
