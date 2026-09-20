import 'package:demix/core/routing/route_paths.dart';
import 'package:demix/core/theme/app_colors.dart';
import 'package:demix/core/widgets/app_background_page.dart';
import 'package:demix/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:demix/features/cart/presentation/pages/widgets/business_header.dart';
import 'package:demix/features/cart/presentation/pages/widgets/cart_item_tile.dart';
import 'package:demix/features/cart/presentation/pages/widgets/empty_card.dart';
import 'package:demix/features/cart/presentation/pages/widgets/summary_row.dart';
import 'package:demix/features/checkout/presentation/pages/checkout_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartCubit>().state;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FB),
      body: AppPageBackground(
        child: Column(
          children: [
            _CartAppBar(onBack: () => context.pop()),

            Expanded(
              child: cart.items.isEmpty
                  ? const EmptyCart()
                  : CustomScrollView(
                      physics: const BouncingScrollPhysics(),
                      slivers: [
                        SliverPadding(
                          padding: const EdgeInsets.fromLTRB(16, 4, 16, 160),
                          sliver: SliverList(
                            delegate: SliverChildListDelegate([
                              if (cart.business != null)
                                BusinessHeader(
                                  businessName: cart.business!.name,
                                  itemCount: cart.itemCount,
                                  image: cart.business!.logoUrl!,
                                ),

                              const SizedBox(height: 16),

                              ...cart.items.map(
                                (item) => Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: CartItemTile(item: item),
                                ),
                              ),

                              const SizedBox(height: 8),

                              AppGlassCard(
                                padding: const EdgeInsets.all(18),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 38,
                                          height: 38,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              13,
                                            ),
                                            gradient: LinearGradient(
                                              colors: [
                                                AppColors.primary.withValues(
                                                  alpha: 0.10,
                                                ),
                                                AppColors.secondary.withValues(
                                                  alpha: 0.10,
                                                ),
                                              ],
                                            ),
                                          ),
                                          child: Icon(
                                            Icons.receipt_long_rounded,
                                            size: 19,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                        const SizedBox(width: 11),
                                        const Text(
                                          'ملخص الطلب',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 18),

                                    SummaryRow('المجموع الفرعي', cart.subtotal),

                                    const SizedBox(height: 9),

                                    SummaryRow(
                                      'التوصيل',
                                      cart.business?.deliveryFee ?? 0,
                                    ),

                                    const Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 14,
                                      ),
                                      child: Divider(
                                        height: 1,
                                        color: Color(0xFFECECF0),
                                      ),
                                    ),

                                    SummaryRow(
                                      'الإجمالي',
                                      cart.subtotal +
                                          (cart.business?.deliveryFee ?? 0),
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
            ),
          ],
        ),
      ),
      bottomNavigationBar: cart.items.isEmpty
          ? null
          : SafeArea(
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 11, 16, 12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.93),
                  border: const Border(
                    top: BorderSide(color: Color(0xFFEDEDF1)),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.07),
                      blurRadius: 24,
                      offset: const Offset(0, -8),
                    ),
                  ],
                ),
                child: AppGradientButton(
                  onPressed: cart.business == null
                      ? null
                      : () {
                          context.push(
                            RoutePaths.checkout,
                            extra: CheckoutArguments(
                              business: cart.business!,
                              items: cart.items,
                            ),
                          );
                        },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'إتمام الطلب',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        height: 23,
                        width: 1,
                        color: Colors.white.withValues(alpha: 0.35),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${(cart.subtotal + (cart.business?.deliveryFee ?? 0)).toStringAsFixed(0)} ج',
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

class _CartAppBar extends StatelessWidget {
  const _CartAppBar({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: SizedBox(
        height: 68,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.82),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.white),
                ),
                child: IconButton(
                  onPressed: onBack,
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
                ),
              ),

              const SizedBox(width: 12),

              const Text(
                'السلة',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
