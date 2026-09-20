import 'package:demix/core/di/injection.dart';
import 'package:demix/core/routing/route_paths.dart';
import 'package:demix/core/theme/app_colors.dart';
import 'package:demix/core/widgets/app_background_page.dart';
import 'package:demix/core/widgets/app_cached_image.dart';
import 'package:demix/features/orders/domain/entities/order_entity.dart';
import 'package:demix/features/orders/domain/entities/order_item_snapshot.dart';
import 'package:demix/features/orders/presentation/cubit/order_tracking_cubit.dart';
import 'package:demix/features/orders/presentation/pages/order_success_page.dart';
import 'package:demix/features/orders/presentation/pages/widgets/section.dart';
import 'package:demix/features/orders/presentation/pages/widgets/status_time_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class OrderDetailsView extends StatelessWidget {
  const OrderDetailsView({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<OrderTrackingCubit>()..watch(orderId),
      child: const _OrderDetailsView(),
    );
  }
}

class _OrderDetailsView extends StatelessWidget {
  const _OrderDetailsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FB),
      body: AppPageBackground(
        child: BlocBuilder<OrderTrackingCubit, OrderTrackingState>(
          builder: (context, state) {
            if (state is OrderTrackingInitial ||
                state is OrderTrackingLoading) {
              return const _Loading();
            }

            if (state is OrderTrackingFailure) {
              return _ErrorState(message: state.message);
            }

            final order = (state as OrderTrackingLoaded).order;

            return _Content(order: order);
          },
        ),
      ),
    );
  }
}

// ============================================================================
// CONTENT
// ============================================================================

class _Content extends StatelessWidget {
  const _Content({required this.order});

  final OrderEntity order;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          pinned: false,
          floating: false,
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          leading: Container(
            margin: const EdgeInsetsDirectional.only(
              start: 8,
              top: 8,
              bottom: 8,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.86),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.white),
            ),
            child: IconButton(
              onPressed: () => context.go(RoutePaths.home),
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 17),
            ),
          ),
          title: const Text(
            'تفاصيل الطلب',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
          ),
        ),

        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 40),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              OrderAnimatedEntry(child: _OrderHero(order: order)),

              const SizedBox(height: 16),

              OrderAnimatedEntry(
                index: 1,
                child: Section(
                  title: 'حالة الطلب',
                  icon: Icons.route_rounded,
                  trailing: OrderStatusBadge(status: order.status),
                  child: StatusTimeline(status: order.status),
                ),
              ),

              const SizedBox(height: 16),

              OrderAnimatedEntry(
                index: 2,
                child: Section(
                  title: 'المنتجات',
                  icon: Icons.restaurant_menu_rounded,
                  trailing: Text(
                    '${order.items.length} منتجات',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  child: _Products(items: order.items),
                ),
              ),

              const SizedBox(height: 16),

              OrderAnimatedEntry(
                index: 3,
                child: Section(
                  title: 'عنوان التوصيل',
                  icon: Icons.location_on_outlined,
                  child: _Address(address: order.address),
                ),
              ),

              const SizedBox(height: 16),

              OrderAnimatedEntry(
                index: 4,
                child: Section(
                  title: 'الدفع',
                  icon: Icons.payments_outlined,
                  child: _PaymentSummary(order: order),
                ),
              ),
            ]),
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// HERO
// ============================================================================

class _OrderHero extends StatelessWidget {
  const _OrderHero({required this.order});

  final OrderEntity order;

  @override
  Widget build(BuildContext context) {
    final businessLogo = order.items.isNotEmpty
        ? order.items.first.businessLogo.trim()
        : '';

    return AppGlassCard(
      padding: const EdgeInsets.all(16),
      radius: 24,
      child: Row(
        children: [
          // Restaurant Logo
          Container(
            width: 58,
            height: 58,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(17),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: businessLogo.isNotEmpty
                  ? AppCachedImage(imageUrl: businessLogo, fit: BoxFit.cover)
                  : Container(
                      color: AppColors.primary.withValues(alpha: 0.07),
                      child: Icon(
                        Icons.restaurant_rounded,
                        color: AppColors.primary,
                        size: 24,
                      ),
                    ),
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.businessName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '#${order.orderNumber}',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
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

// ============================================================================
// PRODUCTS
// ============================================================================

class _Products extends StatelessWidget {
  const _Products({required this.items});

  final List<OrderItemSnapshot> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < items.length; i++) ...[
          _ProductTile(item: items[i]),
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

class _ProductTile extends StatelessWidget {
  const _ProductTile({required this.item});

  final OrderItemSnapshot item;

  @override
  Widget build(BuildContext context) {
    final imageUrl = item.imageUrl?.trim() ?? '';

    final title = item.nameAr?.trim().isNotEmpty == true
        ? item.nameAr!
        : item.name;

    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: imageUrl.isNotEmpty
              ? AppCachedImage(
                  imageUrl: imageUrl,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                )
              : Container(
                  width: 60,
                  height: 60,
                  color: const Color(0xFFF3F3F5),
                  child: Icon(
                    Icons.restaurant_menu_rounded,
                    color: AppColors.textSecondary,
                  ),
                ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  height: 1.3,
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
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  Text(
                    '${item.unitPrice.toStringAsFixed(0)} ج',
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
            fontSize: 12.5,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// ADDRESS
// ============================================================================

class _Address extends StatelessWidget {
  const _Address({required this.address});

  final dynamic address;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8FA),
        borderRadius: BorderRadius.circular(17),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppColors.secondary.withValues(alpha: 0.08),
            ),
            child: Icon(
              Icons.location_on_rounded,
              color: AppColors.secondary,
              size: 19,
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              address.formattedAddress,
              style: const TextStyle(
                fontSize: 12,
                height: 1.55,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// PAYMENT
// ============================================================================

class _PaymentSummary extends StatelessWidget {
  const _PaymentSummary({required this.order});

  final OrderEntity order;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _PriceRow(title: 'المجموع الفرعي', value: order.subtotal),

        const SizedBox(height: 10),

        _PriceRow(title: 'التوصيل', value: order.deliveryFee),

        if (order.discount > 0) ...[
          const SizedBox(height: 10),
          _PriceRow(title: 'الخصم', value: -order.discount),
        ],

        const Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Divider(height: 1, color: Color(0xFFEDEDF1)),
        ),

        Row(
          children: [
            const Expanded(
              child: Text(
                'الإجمالي',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
              ),
            ),
            Text(
              '${order.total.toStringAsFixed(0)} ج',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F8FA),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Row(
            children: [
              Icon(
                Icons.account_balance_wallet_outlined,
                size: 17,
                color: AppColors.secondary,
              ),
              const SizedBox(width: 8),
              Text(
                _paymentLabel(order.paymentMethod),
                style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _paymentLabel(String value) {
    return switch (value) {
      'cashOnDelivery' => 'الدفع عند الاستلام',
      'card' => 'بطاقة بنكية',
      'wallet' => 'محفظة إلكترونية',
      _ => value,
    };
  }
}

class _PriceRow extends StatelessWidget {
  const _PriceRow({required this.title, required this.value});

  final String title;
  final double value;

  @override
  Widget build(BuildContext context) {
    final negative = value < 0;

    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Text(
          '${value.toStringAsFixed(0)} ج',
          style: TextStyle(
            color: negative ? const Color(0xFF16A34A) : AppColors.black,
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// LOADING
// ============================================================================

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator(strokeWidth: 2.5));
  }
}

// ============================================================================
// ERROR
// ============================================================================

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: AppGlassCard(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const OrderIconBox(
                icon: Icons.error_outline_rounded,
                color: Color(0xFFD92D20),
              ),
              const SizedBox(height: 15),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  height: 1.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
