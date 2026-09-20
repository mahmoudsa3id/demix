import 'package:demix/core/di/injection.dart';
import 'package:demix/core/routing/route_paths.dart';
import 'package:demix/core/theme/app_colors.dart';
import 'package:demix/core/widgets/app_background_page.dart';
import 'package:demix/core/widgets/app_cached_image.dart';
import 'package:demix/features/orders/domain/entities/order_entity.dart';
import 'package:demix/features/orders/presentation/cubit/orders_list_cubit.dart';
import 'package:demix/features/orders/presentation/pages/order_success_page.dart';
import 'package:demix/features/orders/presentation/pages/widgets/status_time_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class OrdersView extends StatelessWidget {
  const OrdersViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<OrdersListCubit>()..load(),
      child: const OrdersViewBody(),
    );
  }
}

class OrdersViewBody extends StatelessWidget {
  const OrdersView({super.key});

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
                      child: _OrdersLoading(),
                    )
                  else if (state is OrdersListFailure)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: _OrdersError(
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
                    _OrdersContent(orders: (state as OrdersListLoaded).orders),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// ============================================================================
// CONTENT
// ============================================================================

class _OrdersContent extends StatelessWidget {
  const _OrdersContent({required this.orders});

  final List<OrderEntity> orders;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 35),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final order = orders[index];

          return Padding(
            padding: const EdgeInsets.only(bottom: 11),
            child: OrderAnimatedEntry(
              index: index,
              child: _OrderCard(
                order: order,
                onTap: () {
                  context.push('${RoutePaths.orderDetails}/${order.id}');
                },
              ),
            ),
          );
        }, childCount: orders.length),
      ),
    );
  }
}

// ============================================================================
// CARD
// ============================================================================

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order, required this.onTap});

  final OrderEntity order;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final logo = order.businessImageUrl?.trim() ?? '';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(25),
        child: AppGlassCard(
          padding: const EdgeInsets.all(15),
          radius: 25,
          child: Row(
            children: [
              _BusinessImage(imageUrl: logo),

              const SizedBox(width: 13),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'طلب #${order.orderNumber}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w900,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      order.businessName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 8),

                    OrderStatusBadge(status: order.status),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${order.total.toStringAsFixed(0)} ج',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F7FA),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.chevron_left_rounded,
                      color: AppColors.textSecondary,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// BUSINESS IMAGE
// ============================================================================

class _BusinessImage extends StatelessWidget {
  const _BusinessImage({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return const OrderIconBox(icon: Icons.restaurant_rounded);
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(17),
      child: AppCachedImage(
        imageUrl: imageUrl,
        width: 54,
        height: 54,
        fit: BoxFit.cover,
      ),
    );
  }
}

// ============================================================================
// LOADING
// ============================================================================

class _OrdersLoading extends StatelessWidget {
  const _OrdersLoading();

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator(strokeWidth: 2.4));
  }
}

// ============================================================================
// ERROR
// ============================================================================

class _OrdersError extends StatelessWidget {
  const _OrdersError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: AppGlassCard(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const OrderIconBox(
                icon: Icons.error_outline_rounded,
                color: Color(0xFFD92D20),
              ),

              const SizedBox(height: 15),

              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  height: 1.5,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 18),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(
                  onPressed: onRetry,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    'إعادة المحاولة',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
