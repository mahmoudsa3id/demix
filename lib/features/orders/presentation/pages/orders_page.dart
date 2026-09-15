import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:demix/core/routing/route_paths.dart';
import 'package:demix/features/orders/presentation/cubit/orders_list_cubit.dart';
import 'package:demix/main.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});
  @override
  Widget build(BuildContext c) => BlocProvider(
    create: (_) => getIt<OrdersListCubit>()..load(),
    child: Scaffold(
      appBar: AppBar(title: const Text('طلباتي')),
      body: BlocBuilder<OrdersListCubit, OrdersListState>(
        builder: (c, s) {
          if (s is OrdersListLoading || s is OrdersListInitial)
            return const Center(child: CircularProgressIndicator());
          if (s is OrdersListFailure) return Center(child: Text(s.message));
          if (s is OrdersListEmpty)
            return const Center(child: Text('لسه معملتش أي طلبات'));
          final orders = (s as OrdersListLoaded).orders;
          return RefreshIndicator(
            onRefresh: () => c.read<OrdersListCubit>().load(),
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 30),
              itemCount: orders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) {
                final d = orders[i].data();
                final total = (d!['total'] as num?)?.toDouble() ?? 0;
                final id = orders[i].id;
                return InkWell(
                  onTap: () => c.push('${RoutePaths.orderDetails}/$id'),
                  borderRadius: BorderRadius.circular(22),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(c).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Theme.of(c).colorScheme.primaryContainer,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.receipt_long_rounded,
                            color: Theme.of(c).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'طلب #${d['orderNumber'] ?? ''}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                d['businessName']?.toString() ?? '',
                                style: TextStyle(
                                  color: Theme.of(
                                    c,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                _status(d['status']?.toString() ?? 'pending'),
                                style: TextStyle(
                                  color: Theme.of(c).colorScheme.primary,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '${total.toStringAsFixed(0)} ج',
                          style: const TextStyle(fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(width: 5),
                        const Icon(Icons.chevron_left_rounded),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    ),
  );
}

String _status(String s) => switch (s) {
  'pending' => 'قيد المراجعة',
  'accepted' => 'تم قبول الطلب',
  'preparing' => 'جاري التحضير',
  'outForDelivery' => 'في الطريق',
  'delivered' => 'تم التوصيل',
  'cancelled' => 'تم إلغاء الطلب',
  _ => s,
};
