import 'package:demix/core/theme/app_colors.dart';
import 'package:demix/features/checkout/presentation/pages/widgets/price_row.dart';
import 'package:demix/features/orders/domain/entities/order_entity.dart';
import 'package:flutter/material.dart';

class PaymentSummary extends StatelessWidget {
  const PaymentSummary({super.key, required this.order});

  final OrderEntity order;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PriceRow(title: 'المجموع الفرعي', value: order.subtotal),

        const SizedBox(height: 10),

        PriceRow(title: 'التوصيل', value: order.deliveryFee),

        if (order.discount > 0) ...[
          const SizedBox(height: 10),
          PriceRow(title: 'الخصم', value: -order.discount),
        ],

        const Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Divider(height: 1, color: Color(0xFFEDEDF1)),
        ),

        Row(
          children: [
            const Expanded(
              child: Text(
                'الإجمالي',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
              ),
            ),
            Text(
              '${order.total.toStringAsFixed(0)} ج',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F8FA),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Row(
            children: [
              Icon(
                Icons.account_balance_wallet_outlined,
                size: 17,
                color: AppColors.secondary,
              ),
              const SizedBox(width: 8),
              Text(
                _paymentLabel(order.paymentMethod),
                style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _paymentLabel(String value) {
    return switch (value) {
      'cashOnDelivery' => 'الدفع عند الاستلام',
      'card' => 'بطاقة بنكية',
      'wallet' => 'محفظة إلكترونية',
      _ => value,
    };
  }
}
