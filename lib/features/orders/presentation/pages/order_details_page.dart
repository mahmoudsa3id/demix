import 'package:demix/features/orders/presentation/pages/widgets/section.dart';
import 'package:demix/features/orders/presentation/pages/widgets/status_time_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:demix/features/orders/presentation/cubit/order_tracking_cubit.dart';
import 'package:demix/main.dart';

class OrderDetailsPage extends StatelessWidget {
  const OrderDetailsPage({super.key, required this.orderId});
  final String orderId;
  @override
  Widget build(BuildContext c) => BlocProvider(
    create: (_) => getIt<OrderTrackingCubit>()..watch(orderId),
    child: Scaffold(
      appBar: AppBar(title: const Text('تفاصيل الطلب')),
      body: BlocBuilder<OrderTrackingCubit, OrderTrackingState>(
        builder: (c, state) {
          if (state is OrderTrackingLoading || state is OrderTrackingInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is OrderTrackingFailure) {
            return Center(child: Text(state.message));
          }
          final d = (state as OrderTrackingLoaded).data;
          final status = d['status']?.toString() ?? 'pending';
          final total = (d['total'] as num?)?.toDouble() ?? 0;
          final items = (d['items'] as List?) ?? const [];
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 30),
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Theme.of(c).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'طلب #${d['orderNumber'] ?? ''}',
                      style: const TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      d['businessName']?.toString() ?? '',
                      style: TextStyle(
                        color: Theme.of(c).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 16),
                    StatusTimeline(status: status),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Section(
                title: 'المنتجات',
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Theme.of(c).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Column(
                    children: items.map((raw) {
                      final m = Map<String, dynamic>.from(raw as Map);
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 7),
                        child: Row(
                          children: [
                            Container(
                              width: 34,
                              height: 34,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Theme.of(c).colorScheme.primaryContainer,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '${m['quantity'] ?? 1}',
                                style: TextStyle(
                                  color: Theme.of(c).colorScheme.primary,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                m['nameAr']?.toString().isNotEmpty == true
                                    ? m['nameAr'].toString()
                                    : m['name']?.toString() ?? '',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Text(
                              '${((m['lineTotal'] as num?)?.toDouble() ?? 0).toStringAsFixed(0)} ج',
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Section(
                title: 'التوصيل',
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(c).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Text(
                    (d['address'] as Map?)?['formattedAddress']?.toString() ??
                        '',
                    style: const TextStyle(
                      height: 1.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Theme.of(c).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Row(
                  children: [
                    const Text(
                      'الإجمالي',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const Spacer(),
                    Text(
                      '${total.toStringAsFixed(0)} ج',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: Theme.of(c).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    ),
  );
}
