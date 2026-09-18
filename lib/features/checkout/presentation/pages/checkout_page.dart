import 'package:demix/features/checkout/presentation/pages/widgets/address_card.dart';
import 'package:demix/features/checkout/presentation/pages/widgets/checkout_bottom_bar.dart';
import 'package:demix/features/checkout/presentation/pages/widgets/checkout_header.dart';
import 'package:demix/features/checkout/presentation/pages/widgets/checkout_section.dart';
import 'package:demix/features/checkout/presentation/pages/widgets/order_item_card.dart';
import 'package:demix/features/checkout/presentation/pages/widgets/price_summary.dart';
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
              CheckoutHeader(
                business: widget.arguments.business,
                itemsCount: widget.arguments.items.length,
              ),

              const SizedBox(height: 20),

              CheckoutSection(
                title: 'عنوان التوصيل',
                icon: Icons.location_on_outlined,
                child: AddressCard(address: _address, onTap: _chooseAddress),
              ),

              const SizedBox(height: 20),

              CheckoutSection(
                title: 'ملخص الطلب',
                icon: Icons.receipt_long_outlined,
                child: OrderItemsCard(items: widget.arguments.items),
              ),

              const SizedBox(height: 20),

              CheckoutSection(
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

              CheckoutSection(
                title: 'تفاصيل السعر',
                icon: Icons.payments_outlined,
                child: PriceSummary(
                  subtotal: subtotal,
                  deliveryFee: deliveryFee,
                  total: total,
                ),
              ),
            ],
          ),
          bottomNavigationBar: CheckoutBottomBar(
            total: total,
            addressSelected: _address != null,
            onPressed: _placeOrder,
          ),
        ),
      ),
    );
  }
}
