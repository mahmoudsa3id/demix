import 'package:demix/core/di/injection.dart';
import 'package:demix/core/routing/route_paths.dart';
import 'package:demix/core/theme/app_colors.dart';
import 'package:demix/core/widgets/app_background_page.dart';
import 'package:demix/core/widgets/app_cached_image.dart';
import 'package:demix/features/business/domain/entities/business.dart';
import 'package:demix/features/cart/domain/entities/cart_item.dart';
import 'package:demix/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:demix/features/checkout/presentation/pages/widgets/address_card.dart';
import 'package:demix/features/checkout/presentation/pages/widgets/price_summary.dart';
import 'package:demix/features/location/domain/entities/location_entity.dart';
import 'package:demix/features/location/presentation/cubit/saved_location_cubit.dart';
import 'package:demix/features/orders/domain/entities/order_entity.dart';
import 'package:demix/features/orders/domain/entities/order_item_snapshot.dart';
import 'package:demix/features/orders/presentation/cubit/order_cubit.dart';
import 'package:demix/features/orders/presentation/cubit/order_state.dart';
import 'package:demix/features/payment/domain/entities/payment_method.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

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

  PaymentMethod? _payment;

  late final OrderCubit _orderCubit;
  late final SavedLocationCubit _savedLocationCubit;

  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressDetailsController;

  String? _orderNumber;

  @override
  void initState() {
    super.initState();

    _orderCubit = getIt<OrderCubit>();
    _savedLocationCubit = getIt<SavedLocationCubit>();
    _loadSavedLocation();

    final user = FirebaseAuth.instance.currentUser;

    _nameController = TextEditingController(
      text: user?.displayName?.trim() ?? '',
    );
    _phoneController = TextEditingController(
      text: user?.phoneNumber?.trim() ?? '',
    );

    _addressDetailsController = TextEditingController();
  }

  @override
  void dispose() {
    _orderCubit.close();
    _savedLocationCubit.close();
    _nameController.dispose();
    _phoneController.dispose();
    _addressDetailsController.dispose();
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

  DeliveryAddressSnapshot _snapshotFromLocation(LocationEntity location) {
    return DeliveryAddressSnapshot(
      formattedAddress: location.formattedAddress ?? '',
      street: location.street ?? '',
      area: location.area ?? '',
      city: location.city ?? '',
      latitude: location.latitude,
      longitude: location.longitude,
    );
  }

  Future<void> _loadSavedLocation() async {
    await _savedLocationCubit.load();

    final state = _savedLocationCubit.state;

    if (!mounted || _address != null) return;

    if (state is SavedLocationLoaded && state.location != null) {
      setState(() {
        _address = _snapshotFromLocation(state.location!);
      });
    }
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

    final customerName = _nameController.text.trim();
    final customerPhone = _phoneController.text.trim();
    final addressDetails = _addressDetailsController.text.trim();

    if (customerName.isEmpty) {
      _showMessage('اكتب اسم المستلم');
      return;
    }

    if (customerPhone.isEmpty) {
      _showMessage('اكتب رقم الموبايل');
      return;
    }

    if (_payment == null) {
      _showMessage('اختار طريقة الدفع الأول');
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
      businessImageUrl: widget.arguments.business.logoUrl,

      items: widget.arguments.items
          .map(
            (item) => OrderItemSnapshot(
              productId: item.product.id,
              businessLogo: widget.arguments.business.logoUrl ?? '',
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
      customerName: customerName,
      customerPhone: customerPhone,
      addressDetails: addressDetails.isEmpty ? null : addressDetails,
      subtotal: subtotal,
      deliveryFee: deliveryFee,
      discount: 0,
      total: total,
      paymentMethod: _payment!.name,
      status: 'pending',
      createdAt: DateTime.now(),
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
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _orderCubit),
        BlocProvider.value(value: _savedLocationCubit),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<SavedLocationCubit, SavedLocationState>(
            listener: (context, state) {
              if (state is SavedLocationLoaded) {
                final location = state.location;

                if (location != null && _address == null) {
                  setState(() {
                    _address = _snapshotFromLocation(location);
                  });
                }
              }
            },
          ),
          BlocListener<OrderCubit, OrderState>(
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
          ),
        ],
        child: Scaffold(
          body: AppPageBackground(
            child: Column(
              children: [
                Expanded(
                  child: CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      const SliverToBoxAdapter(child: _CheckoutTopBar()),

                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate([
                            _RestaurantHero(
                              business: widget.arguments.business,
                              itemsCount: widget.arguments.items.length,
                            ),

                            const SizedBox(height: 20),

                            BlocBuilder<SavedLocationCubit, SavedLocationState>(
                              builder: (context, state) {
                                return _DeliverySection(
                                  address: _address,
                                  onChooseAddress: _chooseAddress,
                                  nameController: _nameController,
                                  phoneController: _phoneController,
                                  addressDetailsController:
                                      _addressDetailsController,
                                  loading:
                                      state is SavedLocationLoading ||
                                      state is SavedLocationInitial,
                                );
                              },
                            ),

                            const SizedBox(height: 16),

                            _CheckoutSectionCard(
                              icon: Icons.restaurant_menu_rounded,
                              title: 'طلبك',
                              trailing: Text(
                                '${widget.arguments.items.length} منتجات',
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              child: _ProductList(
                                items: widget.arguments.items,
                              ),
                            ),

                            const SizedBox(height: 16),

                            _CheckoutSectionCard(
                              icon: Icons.account_balance_wallet_outlined,
                              title: 'طريقة الدفع',
                              child: _CheckoutPaymentSelector(
                                value: _payment,
                                onChanged: (value) {
                                  setState(() {
                                    _payment = value;
                                  });
                                },
                              ),
                            ),

                            const SizedBox(height: 16),

                            _CheckoutSectionCard(
                              icon: Icons.receipt_long_rounded,
                              title: 'تفاصيل الدفع',
                              child: PriceSummary(
                                subtotal: subtotal,
                                deliveryFee: deliveryFee,
                                total: total,
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
          bottomNavigationBar: _CheckoutBottomBar(
            total: total,
            addressSelected:
                _address != null &&
                _nameController.text.trim().isNotEmpty &&
                _phoneController.text.trim().isNotEmpty &&
                _payment != null,
            onPressed: _placeOrder,
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// DELIVERY SECTION
// ============================================================================

class _DeliverySection extends StatelessWidget {
  const _DeliverySection({
    required this.address,
    required this.onChooseAddress,
    required this.nameController,
    required this.phoneController,
    required this.addressDetailsController,
    required this.loading,
  });

  final DeliveryAddressSnapshot? address;
  final VoidCallback onChooseAddress;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController addressDetailsController;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return _CheckoutSectionCard(
      icon: Icons.location_on_outlined,
      title: 'بيانات التوصيل',
      trailing: TextButton(
        onPressed: onChooseAddress,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(
          address == null ? 'اختار عنوان' : 'تغيير',
          style: const TextStyle(
            color: AppColors.primary,
            fontSize: 11,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      child: Column(
        children: [
          if (loading && address == null)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'جاري تحميل العنوان المحفوظ...',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            )
          else ...[
            AddressCard(address: address, onTap: onChooseAddress),

            const SizedBox(height: 14),

            _SectionLabel(
              icon: Icons.person_outline_rounded,
              text: 'بيانات المستلم',
            ),

            const SizedBox(height: 10),

            _CheckoutTextField(
              controller: nameController,
              label: 'اسم المستلم',
              hint: 'اكتب اسم المستلم',
              icon: Icons.person_outline_rounded,
              textInputAction: TextInputAction.next,
            ),

            const SizedBox(height: 10),

            _CheckoutTextField(
              controller: phoneController,
              label: 'رقم الموبايل',
              hint: '01xxxxxxxxx',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
            ),

            const SizedBox(height: 10),

            _CheckoutTextField(
              controller: addressDetailsController,
              label: 'تفاصيل العنوان',
              hint: 'مثال: الدور الثالث، شقة 8، بجوار صيدلية النور',
              icon: Icons.notes_outlined,
              maxLines: 3,
              keyboardType: TextInputType.multiline,
            ),

            const SizedBox(height: 8),

            const Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                'تفاصيل العنوان اختيارية ويمكن تعديلها قبل تأكيد الطلب.',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 9.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.primary),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900),
        ),
      ],
    );
  }
}

class _CheckoutTextField extends StatelessWidget {
  const _CheckoutTextField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.keyboardType,
    this.textInputAction,
    this.maxLines = 1,
    this.onChanged,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final int maxLines;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      maxLines: maxLines,
      onChanged: onChanged,
      textDirection: TextDirection.rtl,
      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, size: 19),
        filled: true,
        fillColor: const Color(0xFFF8F8FB),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFFEDEDF2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFFEDEDF2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.2),
        ),
      ),
    );
  }
}

// ============================================================================
// PAYMENT SELECTOR
// ============================================================================

class _CheckoutPaymentSelector extends StatelessWidget {
  const _CheckoutPaymentSelector({
    required this.value,
    required this.onChanged,
  });

  final PaymentMethod? value;
  final ValueChanged<PaymentMethod> onChanged;

  @override
  Widget build(BuildContext context) {
    const methods = [
      (
        method: PaymentMethod.cashOnDelivery,
        icon: Icons.payments_outlined,
        title: 'الدفع عند الاستلام',
        subtitle: 'ادفع قيمة الطلب عند استلامه',
      ),
      (
        method: PaymentMethod.visa,
        icon: Icons.credit_card_outlined,
        title: 'بطاقة بنكية',
        subtitle: 'فيزا أو ماستر كارد',
      ),
    ];

    return Column(
      children: [
        for (var i = 0; i < methods.length; i++) ...[
          _PaymentOption(
            method: methods[i].method,
            icon: methods[i].icon,
            title: methods[i].title,
            subtitle: methods[i].subtitle,
            selected: value == methods[i].method,
            onTap: () => onChanged(methods[i].method),
          ),
          if (i != methods.length - 1) const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _PaymentOption extends StatelessWidget {
  const _PaymentOption({
    required this.method,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final PaymentMethod method;
  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(17),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.primary.withValues(alpha: 0.07)
                : const Color(0xFFF8F8FB),
            borderRadius: BorderRadius.circular(17),
            border: Border.all(
              color: selected
                  ? AppColors.primary.withValues(alpha: 0.45)
                  : const Color(0xFFEDEDF2),
              width: selected ? 1.3 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: selected
                      ? AppColors.primary.withValues(alpha: 0.12)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  icon,
                  color: selected ? AppColors.primary : AppColors.textSecondary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected
                        ? AppColors.primary
                        : const Color(0xFFC9CAD1),
                    width: 1.5,
                  ),
                ),
                child: selected
                    ? Center(
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// TOP BAR
// ============================================================================

class _CheckoutTopBar extends StatelessWidget {
  const _CheckoutTopBar();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: SizedBox(
        height: 72,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Container(
                width: 43,
                height: 43,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.88),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.white, width: 1.1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.035),
                      blurRadius: 15,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: () => context.pop(),
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 17),
                ),
              ),

              const SizedBox(width: 12),

              const Expanded(
                child: Text(
                  'تأكيد الطلب',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.6,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// RESTAURANT HERO
// ============================================================================

class _RestaurantHero extends StatelessWidget {
  const _RestaurantHero({required this.business, required this.itemsCount});

  final Business business;
  final int itemsCount;

  @override
  Widget build(BuildContext context) {
    final imageUrl = (business.logoUrl ?? '').trim();

    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: SizedBox(
        height: 205,
        child: Stack(
          fit: StackFit.expand,
          children: [
            imageUrl.isNotEmpty
                ? AppCachedImage(imageUrl: imageUrl, fit: BoxFit.cover)
                : Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [AppColors.primary, AppColors.secondary],
                      ),
                    ),
                  ),

            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.03),
                      Colors.black.withValues(alpha: 0.70),
                    ],
                    stops: const [0.25, 1],
                  ),
                ),
              ),
            ),

            Positioned(
              top: 14,
              right: 14,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.90),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.shopping_bag_outlined, size: 14),
                    const SizedBox(width: 6),
                    Text(
                      '$itemsCount منتجات',
                      style: const TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Positioned(
              left: 18,
              right: 18,
              bottom: 17,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          business.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 23,
                            fontWeight: FontWeight.w900,
                            height: 1.05,
                          ),
                        ),
                        const SizedBox(height: 7),
                        Row(
                          children: [
                            const Icon(
                              Icons.local_shipping_outlined,
                              color: Colors.white70,
                              size: 14,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              'رسوم التوصيل ${business.deliveryFee.toStringAsFixed(0)} ج',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 10.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Container(
                    width: 54,
                    height: 54,
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(17),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: imageUrl.isNotEmpty
                          ? AppCachedImage(
                              imageUrl: imageUrl,
                              fit: BoxFit.cover,
                            )
                          : Icon(
                              Icons.restaurant_rounded,
                              color: AppColors.primary,
                            ),
                    ),
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

// ============================================================================
// SECTION
// ============================================================================

class _CheckoutSectionCard extends StatelessWidget {
  const _CheckoutSectionCard({
    required this.icon,
    required this.title,
    required this.child,
    this.trailing,
  });

  final IconData icon;
  final String title;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.90),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white, width: 1.1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 22,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(13),
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: 0.10),
                      AppColors.secondary.withValues(alpha: 0.09),
                    ],
                  ),
                ),
                child: Icon(icon, size: 18, color: AppColors.primary),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),

              if (trailing != null) trailing!,
            ],
          ),

          const SizedBox(height: 15),

          child,
        ],
      ),
    );
  }
}

// ============================================================================
// PRODUCTS
// ============================================================================

class _ProductList extends StatelessWidget {
  const _ProductList({required this.items});

  final List<CartItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < items.length; i++) ...[
          _ProductCheckoutTile(item: items[i]),
          if (i != items.length - 1)
            const Padding(
              padding: EdgeInsets.only(left: 66, top: 11, bottom: 11),
              child: Divider(height: 1, color: Color(0xFFEFEFF2)),
            ),
        ],
      ],
    );
  }
}

class _ProductCheckoutTile extends StatelessWidget {
  const _ProductCheckoutTile({required this.item});

  final CartItem item;

  @override
  Widget build(BuildContext context) {
    final imageUrl = item.product.imageUrl!.trim();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(17),
          child: SizedBox(
            width: 58,
            height: 58,
            child: imageUrl.isNotEmpty
                ? AppCachedImage(
                    imageUrl: imageUrl,
                    width: 58,
                    height: 58,
                    fit: BoxFit.cover,
                  )
                : Container(
                    color: const Color(0xFFF2F2F5),
                    child: Icon(
                      Icons.restaurant_menu_rounded,
                      color: AppColors.textSecondary,
                      size: 23,
                    ),
                  ),
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
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  height: 1.25,
                ),
              ),

              const SizedBox(height: 6),

              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.07),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '× ${item.quantity}',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${item.product.price.toStringAsFixed(0)} ج',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(width: 10),

        Text(
          '${item.lineTotal.toStringAsFixed(0)} ج',
          style: TextStyle(
            color: AppColors.black,
            fontSize: 13,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// BOTTOM BAR
// ============================================================================

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
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 11, 16, 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.95),
          border: const Border(top: BorderSide(color: Color(0xFFECECF0))),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.07),
              blurRadius: 25,
              offset: const Offset(0, -10),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'الإجمالي',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${total.toStringAsFixed(0)} ج',
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              flex: 2,
              child: SizedBox(
                height: 54,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: addressSelected
                        ? LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [AppColors.primary, AppColors.secondary],
                          )
                        : null,
                    color: addressSelected ? null : const Color(0xFFE4E4E8),
                    borderRadius: BorderRadius.circular(17),
                    boxShadow: addressSelected
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.18),
                              blurRadius: 18,
                              offset: const Offset(0, 8),
                            ),
                          ]
                        : null,
                  ),
                  child: FilledButton(
                    onPressed: addressSelected ? onPressed : null,
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      disabledBackgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      disabledForegroundColor: const Color(0xFF9999A0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(17),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'تأكيد الطلب',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 13.5,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward_rounded, size: 18),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
