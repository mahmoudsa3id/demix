import 'package:demix/core/widgets/app_cached_image.dart';
import 'package:demix/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:demix/features/cart/presentation/pages/widgets/q.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartItemTile extends StatelessWidget {
  const CartItemTile({super.key, required this.item});
  final dynamic item;
  @override
  Widget build(BuildContext c) {
    final cart = c.read<CartCubit>();
    final s = Theme.of(c).colorScheme;
    return Dismissible(
      key: ValueKey(item.product.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => cart.remove(item.product.id),
      background: Container(
        alignment: AlignmentDirectional.centerEnd,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: s.errorContainer,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Icon(Icons.delete_outline, color: s.onErrorContainer),
      ),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: s.surface,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: s.outlineVariant),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SizedBox(
                width: 86,
                height: 86,
                child:
                    item.product.imageUrl == null ||
                        item.product.imageUrl!.isEmpty
                    ? Container(
                        color: s.surfaceContainerHighest,
                        child: Icon(Icons.fastfood_rounded, color: s.primary),
                      )
                    : AppCachedImage(imageUrl: item.product.imageUrl!),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${item.product.price.toStringAsFixed(0)} ج',
                    style: TextStyle(
                      color: s.primary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Q(
                        icon: Icons.remove_rounded,
                        onTap: () => cart.decrease(item.product.id),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 13),
                        child: Text(
                          '${item.quantity}',
                          style: const TextStyle(fontWeight: FontWeight.w900),
                        ),
                      ),
                      Q(
                        icon: Icons.add_rounded,
                        onTap: () => cart.increase(item.product.id),
                      ),
                      const Spacer(),
                      Text(
                        '${item.lineTotal.toStringAsFixed(0)} ج',
                        style: const TextStyle(fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
