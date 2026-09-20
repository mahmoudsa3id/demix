import 'package:demix/core/routing/route_paths.dart';
import 'package:demix/core/theme/app_colors.dart';
import 'package:demix/features/orders/domain/entities/order_entity.dart';
import 'package:demix/features/orders/presentation/pages/widgets/order_animated_entry.dart';
import 'package:demix/features/orders/presentation/pages/widgets/order_details_view_address.dart';
import 'package:demix/features/orders/presentation/pages/widgets/order_details_view_hero.dart';
import 'package:demix/features/orders/presentation/pages/widgets/order_details_view_products.dart';
import 'package:demix/features/orders/presentation/pages/widgets/price_summary.dart';
import 'package:demix/features/orders/presentation/pages/widgets/section.dart';
import 'package:demix/features/orders/presentation/pages/widgets/status_time_line.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OrderDetailsViewContent extends StatelessWidget {
  const OrderDetailsViewContent({super.key, required this.order});

  final OrderEntity order;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          pinned: false,
          floating: false,
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          leading: Container(
            margin: const EdgeInsetsDirectional.only(
              start: 8,
              top: 8,
              bottom: 8,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.86),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.white),
            ),
            child: IconButton(
              onPressed: () => context.go(RoutePaths.home),
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 17),
            ),
          ),
          title: const Text(
            'تفاصيل الطلب',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
          ),
        ),

        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 40),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              OrderAnimatedEntry(child: OrderDetailsViewHero(order: order)),

              const SizedBox(height: 16),

              OrderAnimatedEntry(
                index: 1,
                child: Section(
                  title: 'حالة الطلب',
                  icon: Icons.route_rounded,
                  trailing: OrderStatusBadge(status: order.status),
                  child: StatusTimeline(status: order.status),
                ),
              ),

              const SizedBox(height: 16),

              OrderAnimatedEntry(
                index: 2,
                child: Section(
                  title: 'المنتجات',
                  icon: Icons.restaurant_menu_rounded,
                  trailing: Text(
                    '${order.items.length} منتجات',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  child: OrderDetailsViewProducts(items: order.items),
                ),
              ),

              const SizedBox(height: 16),

              OrderAnimatedEntry(
                index: 3,
                child: Section(
                  title: 'عنوان التوصيل',
                  icon: Icons.location_on_outlined,
                  child: OrderDetailsViewAddress(address: order.address),
                ),
              ),

              const SizedBox(height: 16),

              OrderAnimatedEntry(
                index: 4,
                child: Section(
                  title: 'الدفع',
                  icon: Icons.payments_outlined,
                  child: PaymentSummary(order: order),
                ),
              ),
            ]),
          ),
        ),
      ],
    );
  }
}
