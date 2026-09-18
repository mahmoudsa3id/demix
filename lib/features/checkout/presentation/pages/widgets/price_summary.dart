import 'package:demix/features/checkout/presentation/pages/widgets/price_row.dart';
import 'package:flutter/material.dart';

class PriceSummary extends StatelessWidget {
  const PriceSummary({
    super.key,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
  });

  final double subtotal;
  final double deliveryFee;
  final double total;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          PriceRow(title: 'المجموع الفرعي', value: subtotal),
          const SizedBox(height: 10),
          PriceRow(title: 'رسوم التوصيل', value: deliveryFee),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Divider(color: colors.outlineVariant),
          ),
          Row(
            children: [
              const Text(
                'الإجمالي',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
              ),
              const Spacer(),
              Text(
                '${total.toStringAsFixed(0)} ج',
                style: TextStyle(
                  color: colors.primary,
                  fontSize: 21,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
