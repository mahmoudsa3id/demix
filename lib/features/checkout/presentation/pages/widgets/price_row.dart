import 'package:flutter/material.dart';

class PriceRow extends StatelessWidget {
  const PriceRow({super.key, required this.title, required this.value});

  final String title;
  final double value;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            color: colors.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Spacer(),
        Text(
          '${value.toStringAsFixed(0)} ج',
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ],
    );
  }
}

// ============================================================
// BOTTOM BAR
// ============================================================
