import 'package:demix/core/theme/app_colors.dart';
import 'package:demix/core/widgets/app_background_page.dart';
import 'package:demix/features/orders/presentation/cubit/orders_list_cubit.dart';
import 'package:demix/features/orders/presentation/cubit/orders_list_state.dart';
import 'package:demix/features/orders/presentation/pages/widgets/order_empty_state.dart';
import 'package:demix/features/orders/presentation/pages/widgets/orders_content.dart';
import 'package:demix/features/orders/presentation/pages/widgets/orders_error.dart';
import 'package:demix/features/orders/presentation/pages/widgets/orders_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrdersViewBody extends StatelessWidget {
  const OrdersViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FB),
      body: AppPageBackground(
        child: BlocBuilder<OrdersListCubit, OrdersListState>(
          builder: (context, state) {
            return RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () {
                return context.read<OrdersListCubit>().load();
              },
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                slivers: [
                  SliverAppBar(
                    pinned: false,
                    floating: false,
                    elevation: 0,
                    scrolledUnderElevation: 0,
                    backgroundColor: Colors.transparent,
                    surfaceTintColor: Colors.transparent,
                    title: const Text(
                      'طلباتي',
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.6,
                      ),
                    ),
                  ),

                  if (state is OrdersListInitial || state is OrdersListLoading)
                    const SliverFillRemaining(
                      hasScrollBody: false,
                      child: OrdersLoading(),
                    )
                  else if (state is OrdersListFailure)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: ErrorState(
                        message: state.message,
                        onRetry: () {
                          context.read<OrdersListCubit>().load();
                        },
                      ),
                    )
                  else if (state is OrdersListEmpty)
                    const SliverFillRemaining(
                      hasScrollBody: false,
                      child: OrdersEmptyState(
                        title: 'لسه مفيش طلبات',
                        subtitle:
                            'أول ما تطلب من مطعم أو كافيه هتلاقي طلبك هنا.',
                      ),
                    )
                  else
                    OrdersContent(orders: (state as OrdersListLoaded).orders),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
