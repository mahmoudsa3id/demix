import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:demix/core/routing/route_paths.dart';

class OrderSuccessPage extends StatelessWidget {
  const OrderSuccessPage({
    super.key,
    required this.orderId,
    required this.orderNumber,
  });
  final String orderId, orderNumber;
  @override
  Widget build(BuildContext c) {
    final s = Theme.of(c).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 112,
                height: 112,
                decoration: BoxDecoration(
                  color: s.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check_rounded, size: 64, color: s.primary),
              ),
              const SizedBox(height: 26),
              const Text(
                'تم تأكيد طلبك 🎉',
                style: TextStyle(fontSize: 27, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 9),
              Text(
                'الطلب رقم #$orderNumber',
                style: TextStyle(color: s.onSurfaceVariant),
              ),
              const SizedBox(height: 14),
              Text(
                'المطعم بدأ يستقبل طلبك، وتقدر تتابع حالته لحظة بلحظة.',
                textAlign: TextAlign.center,
                style: TextStyle(color: s.onSurfaceVariant, height: 1.5),
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: s.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.delivery_dining_rounded),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'تابع حالة الطلب من شاشة التتبع.',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => c.go('${RoutePaths.orderDetails}/$orderId'),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    child: Text(
                      'تتبع الطلب',
                      style: TextStyle(fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () => c.go(RoutePaths.home),
                child: const Text('العودة للرئيسية'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
