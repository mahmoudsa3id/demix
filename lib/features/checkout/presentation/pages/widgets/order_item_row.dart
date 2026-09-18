import 'package:demix/features/cart/domain/entities/cart_item.dart';
import 'package:flutter/material.dart';

class OrderItemRow extends StatelessWidget {
  const OrderItemRow({super.key, required this.item});

  final CartItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: colors.primaryContainer,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(Icons.fastfood_rounded, color: colors.primary, size: 23),
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
          decoration: BoxDecoration(
            color: colors.primary,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Text(
            '${item.quantity}x',
            style: TextStyle(
              color: colors.onPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            item.product.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '${item.lineTotal.toStringAsFixed(0)} ج',
          style: const TextStyle(fontWeight: FontWeight.w900),
        ),
      ],
    );
  }
}
