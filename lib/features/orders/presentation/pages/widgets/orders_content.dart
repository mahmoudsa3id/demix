import 'package:demix/core/routing/route_paths.dart';
import 'package:demix/features/orders/domain/entities/order_entity.dart';
import 'package:demix/features/orders/presentation/pages/widgets/order_animated_entry.dart';
import 'package:demix/features/orders/presentation/pages/widgets/order_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OrdersContent extends StatelessWidget {
  const OrdersContent({super.key, required this.orders});

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
              child: OrderCard(
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
