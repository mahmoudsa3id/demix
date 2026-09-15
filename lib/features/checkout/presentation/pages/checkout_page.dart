import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:demix/core/routing/route_paths.dart';
import 'package:demix/features/business/domain/entities/business.dart';
import 'package:demix/features/cart/domain/entities/cart_item.dart';
import 'package:demix/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:demix/features/orders/domain/entities/order_entity.dart';
import 'package:demix/features/orders/domain/entities/order_item_snapshot.dart';
import 'package:demix/features/orders/presentation/cubit/order_cubit.dart';
import 'package:demix/features/payment/domain/entities/payment_method.dart';
import 'package:demix/features/payment/presentation/widgets/payment_method_selector.dart';
import 'package:demix/main.dart';

class CheckoutArguments {
  const CheckoutArguments({
    required this.business,
    required this.items,
    this.clearCartAfterOrder = true,
  });

  final Business business;
  final List<CartItem> items;
  final bool clearCartAfterOrder;
}

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key, required this.arguments});

  final CheckoutArguments arguments;

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  DeliveryAddressSnapshot? _address;

  PaymentMethod _payment = PaymentMethod.cashOnDelivery;

  late final OrderCubit _orderCubit;

  String? _orderNumber;

  @override
  void initState() {
    super.initState();
    _orderCubit = getIt<OrderCubit>();
  }

  @override
  void dispose() {
    _orderCubit.close();
    super.dispose();
  }

  double get subtotal {
    return widget.arguments.items.fold(
      0,
      (total, item) => total + item.lineTotal,
    );
  }

  double get deliveryFee {
    return widget.arguments.business.deliveryFee;
  }

  double get total {
    return subtotal + deliveryFee;
  }

  Future<void> _chooseAddress() async {
    final result = await context.push<DeliveryAddressSnapshot>(
      RoutePaths.checkoutLocation,
    );

    if (!mounted || result == null) return;

    setState(() {
      _address = result;
    });
  }

  Future<void> _placeOrder() async {
    final address = _address;

    if (address == null) {
      _showMessage('اختار عنوان التوصيل الأول');
      return;
    }

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      _showMessage('سجل دخولك الأول');
      return;
    }

    final orderNumber =
        'DMX-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';

    _orderNumber = orderNumber;

    final order = OrderEntity(
      id: '',
      orderNumber: orderNumber,
      userId: user.uid,
      businessId: widget.arguments.business.id,
      businessName: widget.arguments.business.name,
      items: widget.arguments.items
          .map(
            (item) => OrderItemSnapshot(
              productId: item.product.id,
              businessId: item.product.businessId,
              categoryId: item.product.categoryId ?? '',
              name: item.product.name,
              nameAr: item.product.nameAr,
              imageUrl: item.product.imageUrl,
              quantity: item.quantity,
              unitPrice: item.product.price,
              lineTotal: item.lineTotal,
            ),
          )
          .toList(),
      address: address,
      subtotal: subtotal,
      deliveryFee: deliveryFee,
      discount: 0,
      total: total,
      paymentMethod: _payment.name,
      status: 'pending',
    );

    await _orderCubit.create(order);
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
      );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _orderCubit,
      child: BlocListener<OrderCubit, OrderState>(
        listener: (context, state) {
          if (state is OrderCreated) {
            if (widget.arguments.clearCartAfterOrder) {
              context.read<CartCubit>().clear();
            }

            context.go(
              '${RoutePaths.orderSuccessPath}/${state.orderId}'
              '?orderNumber=${Uri.encodeComponent(_orderNumber ?? '')}',
            );

            return;
          }

          if (state is OrderFailure) {
            _showMessage(state.message);
          }
        },
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          appBar: AppBar(
            title: const Text(
              'تأكيد الطلب',
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
            centerTitle: false,
          ),
          body: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 160),
            children: [
              _CheckoutHeader(
                business: widget.arguments.business,
                itemsCount: widget.arguments.items.length,
              ),

              const SizedBox(height: 20),

              _CheckoutSection(
                title: 'عنوان التوصيل',
                icon: Icons.location_on_outlined,
                child: _AddressCard(address: _address, onTap: _chooseAddress),
              ),

              const SizedBox(height: 20),

              _CheckoutSection(
                title: 'ملخص الطلب',
                icon: Icons.receipt_long_outlined,
                child: _OrderItemsCard(items: widget.arguments.items),
              ),

              const SizedBox(height: 20),

              _CheckoutSection(
                title: 'طريقة الدفع',
                icon: Icons.account_balance_wallet_outlined,
                child: PaymentMethodSelector(
                  value: _payment,
                  onChanged: (value) {
                    setState(() {
                      _payment = value;
                    });
                  },
                ),
              ),

              const SizedBox(height: 20),

              _CheckoutSection(
                title: 'تفاصيل السعر',
                icon: Icons.payments_outlined,
                child: _PriceSummary(
                  subtotal: subtotal,
                  deliveryFee: deliveryFee,
                  total: total,
                ),
              ),
            ],
          ),
          bottomNavigationBar: _CheckoutBottomBar(
            total: total,
            addressSelected: _address != null,
            onPressed: _placeOrder,
          ),
        ),
      ),
    );
  }
}

// ============================================================
// HEADER
// ============================================================

class _CheckoutHeader extends StatelessWidget {
  const _CheckoutHeader({required this.business, required this.itemsCount});

  final Business business;
  final int itemsCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colors.primaryContainer, colors.surfaceContainerHighest],
        ),
        borderRadius: BorderRadius.circular(26),
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(
              Icons.restaurant_rounded,
              color: colors.primary,
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  business.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '$itemsCount منتجات • ${business.estimatedDeliveryTime} دقيقة',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// SECTION
// ============================================================

class _CheckoutSection extends StatelessWidget {
  const _CheckoutSection({
    required this.title,
    required this.icon,
    required this.child,
  });

  final String title;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: colors.primary),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
            ),
          ],
        ),
        const SizedBox(height: 10),
        child,
      ],
    );
  }
}

// ============================================================
// ADDRESS
// ============================================================

class _AddressCard extends StatelessWidget {
  const _AddressCard({required this.address, required this.onTap});

  final DeliveryAddressSnapshot? address;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final hasAddress = address != null;

    return Material(
      color: colors.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(22),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: colors.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  hasAddress
                      ? Icons.location_on_rounded
                      : Icons.add_location_alt_outlined,
                  color: colors.primary,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hasAddress ? 'عنوان التوصيل' : 'اختار عنوان التوصيل',
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      hasAddress
                          ? address!.formattedAddress
                          : 'اضغط هنا لاختيار موقع التوصيل',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: colors.onSurfaceVariant,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: colors.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// ORDER ITEMS
// ============================================================

class _OrderItemsCard extends StatelessWidget {
  const _OrderItemsCard({required this.items});

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
            _OrderItemRow(item: items[index]),
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

class _OrderItemRow extends StatelessWidget {
  const _OrderItemRow({required this.item});

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

// ============================================================
// PRICE SUMMARY
// ============================================================

class _PriceSummary extends StatelessWidget {
  const _PriceSummary({
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
          _PriceRow(title: 'المجموع الفرعي', value: subtotal),
          const SizedBox(height: 10),
          _PriceRow(title: 'رسوم التوصيل', value: deliveryFee),
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

class _PriceRow extends StatelessWidget {
  const _PriceRow({required this.title, required this.value});

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

class _CheckoutBottomBar extends StatelessWidget {
  const _CheckoutBottomBar({
    required this.total,
    required this.addressSelected,
    required this.onPressed,
  });

  final double total;
  final bool addressSelected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
        decoration: BoxDecoration(
          color: colors.surface,
          boxShadow: [
            BoxShadow(
              blurRadius: 24,
              offset: const Offset(0, -6),
              color: Colors.black.withOpacity(.08),
            ),
          ],
        ),
        child: BlocBuilder<OrderCubit, OrderState>(
          builder: (context, state) {
            final isLoading = state is OrderSubmitting;

            return Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 11,
                  ),
                  decoration: BoxDecoration(
                    color: colors.primaryContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'الإجمالي',
                        style: TextStyle(
                          color: colors.onPrimaryContainer,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${total.toStringAsFixed(0)} ج',
                        style: TextStyle(
                          color: colors.onPrimaryContainer,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton(
                    onPressed: isLoading || !addressSelected ? null : onPressed,
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(17),
                      ),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(strokeWidth: 2.5),
                          )
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'تأكيد الطلب',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward_rounded, size: 20),
                            ],
                          ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
