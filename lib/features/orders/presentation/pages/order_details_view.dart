import 'package:demix/core/di/injection.dart';
import 'package:demix/features/orders/presentation/cubit/order_tracking_cubit.dart';
import 'package:demix/features/orders/presentation/pages/widgets/order_details_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderDetailsView extends StatelessWidget {
  const OrderDetailsView({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<OrderTrackingCubit>()..watch(orderId),
      child: const OrderDetailsViewBody(),
    );
  }
}
