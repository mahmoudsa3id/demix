import 'package:demix/features/orders/domain/entities/order_item_snapshot.dart';
import 'package:demix/features/orders/presentation/pages/widgets/order_details_view_product_tile.dart';
import 'package:flutter/material.dart';

class OrderDetailsViewProducts extends StatelessWidget {
  const OrderDetailsViewProducts({super.key, required this.items});

  final List<OrderItemSnapshot> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < items.length; i++) ...[
          OrderDetailsViewProductTile(item: items[i]),
          if (i != items.length - 1)
            const Padding(
              padding: EdgeInsets.only(left: 74, top: 12, bottom: 12),
              child: Divider(height: 1, color: Color(0xFFEFEFF2)),
            ),
        ],
      ],
    );
  }
}
