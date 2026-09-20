import 'package:demix/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class PriceRow extends StatelessWidget {
  const PriceRow({super.key, required this.title, required this.value});

  final String title;
  final double value;

  @override
  Widget build(BuildContext context) {
    final negative = value < 0;

    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Text(
          '${value.toStringAsFixed(0)} ج',
          style: TextStyle(
            color: negative ? const Color(0xFF16A34A) : AppColors.black,
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
