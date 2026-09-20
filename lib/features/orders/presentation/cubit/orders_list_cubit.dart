import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/order_entity.dart';
import '../../domain/use_cases/get_my_orders_use_case.dart';

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

class OrdersListCubit extends Cubit<OrdersListState> {
  OrdersListCubit({required GetMyOrdersUseCase getMyOrders})
    : _getMyOrders = getMyOrders,
      super(const OrdersListInitial());

  final GetMyOrdersUseCase _getMyOrders;

  Future<void> load() async {
    if (isClosed) return;

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      emit(const OrdersListFailure('Please sign in first.'));
      return;
    }

    emit(const OrdersListLoading());

    try {
      final orders = await _getMyOrders(user.uid);

      if (isClosed) return;

      if (orders.isEmpty) {
        emit(const OrdersListEmpty());
        return;
      }

      emit(OrdersListLoaded(orders));
    } catch (e) {
      if (isClosed) return;

      emit(OrdersListFailure(e.toString()));
    }
  }
}
