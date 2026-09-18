import 'package:demix/features/cart/domain/entities/cart_item.dart';
import 'package:demix/features/checkout/presentation/pages/widgets/order_item_row.dart';
import 'package:flutter/material.dart';

class OrderItemsCard extends StatelessWidget {
  const OrderItemsCard({super.key, required this.items});

  final List<CartItem> items;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          for (int index = 0; index < items.length; index++) ...[
            OrderItemRow(item: items[index]),
            if (index != items.length - 1)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Divider(height: 1, color: colors.outlineVariant),
              ),
          ],
        ],
      ),
    );
  }
}
