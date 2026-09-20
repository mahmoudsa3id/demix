import 'package:demix/core/theme/app_colors.dart';
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
    return Column(
      children: [
        PriceRow(title: 'المجموع الفرعي', value: subtotal),

        const SizedBox(height: 11),

        PriceRow(title: 'التوصيل', value: deliveryFee),

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
              '${total.toStringAsFixed(0)} ج',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 19,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
