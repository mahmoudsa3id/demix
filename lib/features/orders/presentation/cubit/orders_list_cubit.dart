import 'package:demix/features/orders/presentation/cubit/orders_list_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/use_cases/get_my_orders_use_case.dart';

class OrdersListCubit extends Cubit<OrdersListState> {
  OrdersListCubit({required this._getMyOrders})
    : super(const OrdersListInitial());

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
