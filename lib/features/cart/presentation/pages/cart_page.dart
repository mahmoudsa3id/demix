import 'package:demix/core/routing/navigation.dart';
import 'package:demix/features/cart/presentation/pages/widgets/business_header.dart';
import 'package:demix/features/cart/presentation/pages/widgets/cart_item_tile.dart';
import 'package:demix/features/cart/presentation/pages/widgets/empty_card.dart';
import 'package:demix/features/cart/presentation/pages/widgets/summary_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:demix/core/routing/route_paths.dart';
import 'package:demix/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:demix/features/checkout/presentation/pages/checkout_page.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});
  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartCubit>().state;
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('السلة'),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              context.pop();
            },
            icon: Icon(Icons.arrow_back_ios),
          ),
        ],
      ),
      body: cart.items.isEmpty
          ? EmptyCart()
          : CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 150),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      if (cart.business != null)
                        BusinessHeader(
                          businessName: cart.business!.name,
                          itemCount: cart.itemCount,
                          image: cart.business!.logoUrl!,
                        ),
                      const SizedBox(height: 14),
                      ...cart.items.map(
                        (item) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: CartItemTile(item: item),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: scheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: Column(
                          children: [
                            SummaryRow('المجموع الفرعي', cart.subtotal),
                            SummaryRow(
                              'التوصيل',
                              cart.business?.deliveryFee ?? 0,
                            ),
                            const Divider(height: 24),
                            SummaryRow(
                              'الإجمالي',
                              cart.subtotal + (cart.business?.deliveryFee ?? 0),
                              strong: true,
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ),
                ),
              ],
            ),
      bottomNavigationBar: cart.items.isEmpty
          ? null
          : SafeArea(
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
                decoration: BoxDecoration(
                  color: scheme.surface,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 18,
                      color: Colors.black.withOpacity(.08),
                    ),
                  ],
                ),
                child: FilledButton(
                  onPressed: cart.business == null
                      ? null
                      : () => context.push(
                          RoutePaths.checkout,
                          extra: CheckoutArguments(
                            business: cart.business!,
                            items: cart.items,
                          ),
                        ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'إتمام الطلب',
                          style: TextStyle(fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${(cart.subtotal + (cart.business?.deliveryFee ?? 0)).toStringAsFixed(0)} ج',
                          style: const TextStyle(fontWeight: FontWeight.w900),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
