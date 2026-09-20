import 'package:demix/core/widgets/app_background_page.dart';
import 'package:demix/features/orders/presentation/cubit/order_tracking_cubit.dart';
import 'package:demix/features/orders/presentation/cubit/order_tracking_state.dart';
import 'package:demix/features/orders/presentation/pages/widgets/order_details_view_content.dart';
import 'package:demix/features/orders/presentation/pages/widgets/orders_error.dart';
import 'package:demix/features/orders/presentation/pages/widgets/orders_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderDetailsViewBody extends StatelessWidget {
  const OrderDetailsViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FB),
      body: AppPageBackground(
        child: BlocBuilder<OrderTrackingCubit, OrderTrackingState>(
          builder: (context, state) {
            if (state is OrderTrackingInitial ||
                state is OrderTrackingLoading) {
              return const OrdersLoading();
            }

            if (state is OrderTrackingFailure) {
              return ErrorState(message: state.message, onRetry: () {});
            }

            final order = (state as OrderTrackingLoaded).order;

            return OrderDetailsViewContent(order: order);
          },
        ),
      ),
    );
  }
}
