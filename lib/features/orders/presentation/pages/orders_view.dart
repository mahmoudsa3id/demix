import 'package:demix/core/di/injection.dart';
import 'package:demix/features/orders/presentation/cubit/orders_list_cubit.dart';
import 'package:demix/features/orders/presentation/pages/widgets/order_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrdersView extends StatelessWidget {
  const OrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<OrdersListCubit>()..load(),
      child: const OrdersViewBody(),
    );
  }
}
