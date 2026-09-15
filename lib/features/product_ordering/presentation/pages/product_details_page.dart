import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:demix/features/business/domain/entities/business.dart';
import 'package:demix/features/business/domain/entities/product.dart';
import 'package:demix/features/cart/presentation/cubit/cart_cubit.dart';

class ProductDetailsArguments {
  const ProductDetailsArguments({
    required this.product,
    required this.business,
  });

  final Product product;
  final Business business;
}

class ProductDetailsPage extends StatefulWidget {
  const ProductDetailsPage({super.key, required this.arguments});

  final ProductDetailsArguments arguments;

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int _quantity = 1;

  Product get _product => widget.arguments.product;

  Business get _business => widget.arguments.business;

  double get _total => _product.price * _quantity;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(context),

          SliverToBoxAdapter(
            child: _ProductContent(
              product: _product,
              business: _business,
              quantity: _quantity,
              onDecrease: _decreaseQuantity,
              onIncrease: _increaseQuantity,
            ),
          ),
        ],
      ),
      bottomNavigationBar: _ProductBottomBar(
        product: _product,
        total: _total,
        quantity: _quantity,
        onAddToCart: _addToCart,
      ),
    );
  }

  SliverAppBar _buildAppBar(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SliverAppBar(
      expandedHeight: 390,
      pinned: true,
      stretch: true,
      elevation: 0,
      backgroundColor: colors.surface,
      leading: _CircleButton(
        icon: Icons.arrow_back_rounded,
        onTap: () => context.pop(),
      ),
      actions: [
        _CircleButton(
          icon: Icons.favorite_border_rounded,
          onTap: () {
            // TODO: Add favorite functionality.
          },
        ),
        const SizedBox(width: 8),
      ],
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        background: _ProductHeroImage(imageUrl: _product.imageUrl),
      ),
    );
  }

  void _decreaseQuantity() {
    if (_quantity <= 1) return;

    setState(() {
      _quantity--;
    });
  }

  void _increaseQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _addToCart() {
    if (!_product.isAvailable) return;

    try {
      context.read<CartCubit>().addItem(
        product: _product,
        business: _business,
        quantity: _quantity,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            content: const Text(
              'تمت إضافة المنتج إلى السلة',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            action: SnackBarAction(
              label: 'السلة',
              onPressed: () {
                // Cart navigation can be connected from the app router.
              },
            ),
          ),
        );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text(e.toString()),
          ),
        );
    }
  }
}

// ============================================================
// CONTENT
// ============================================================

class _ProductContent extends StatelessWidget {
  const _ProductContent({
    required this.product,
    required this.business,
    required this.quantity,
    required this.onDecrease,
    required this.onIncrease,
  });

  final Product product;
  final Business business;
  final int quantity;

  final VoidCallback onDecrease;
  final VoidCallback onIncrease;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final description = (product.descriptionAr ?? product.description ?? '')
        .trim();

    return Container(
      margin: const EdgeInsets.only(top: 0),
      padding: const EdgeInsets.fromLTRB(20, 26, 20, 150),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHandle(colors),

          const SizedBox(height: 22),

          _ProductTitle(product: product),

          const SizedBox(height: 12),

          _BusinessInfo(business: business),

          if (description.isNotEmpty) ...[
            const SizedBox(height: 28),
            _SectionTitle(title: 'عن المنتج'),
            const SizedBox(height: 9),
            Text(
              description,
              style: theme.textTheme.bodyMedium?.copyWith(
                height: 1.7,
                color: colors.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],

          const SizedBox(height: 28),

          _QuantityCard(
            quantity: quantity,
            onDecrease: onDecrease,
            onIncrease: onIncrease,
          ),

          const SizedBox(height: 18),

          _DeliveryCard(business: business),

          const SizedBox(height: 18),

          _AvailabilityCard(isAvailable: product.isAvailable),
        ],
      ),
    );
  }

  Widget _buildHandle(ColorScheme colors) {
    return Center(
      child: Container(
        width: 42,
        height: 4,
        decoration: BoxDecoration(
          color: colors.outlineVariant,
          borderRadius: BorderRadius.circular(100),
        ),
      ),
    );
  }
}

// ============================================================
// PRODUCT TITLE
// ============================================================

class _ProductTitle extends StatelessWidget {
  const _ProductTitle({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            product.name,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontSize: 25,
              height: 1.15,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const SizedBox(width: 14),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
          decoration: BoxDecoration(
            color: colors.primaryContainer,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Text(
            '${product.price.toStringAsFixed(0)} ج',
            style: TextStyle(
              color: colors.onPrimaryContainer,
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================
// BUSINESS INFO
// ============================================================

class _BusinessInfo extends StatelessWidget {
  const _BusinessInfo({required this.business});

  final Business business;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: colors.primaryContainer,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(
              Icons.storefront_rounded,
              size: 20,
              color: colors.primary,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  business.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 2),
                Text(
                  business.type == 'restaurant' ? 'مطعم' : 'كافيه',
                  style: TextStyle(
                    color: colors.onSurfaceVariant,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            Icons.schedule_rounded,
            size: 17,
            color: colors.onSurfaceVariant,
          ),
          const SizedBox(width: 5),
          Text(
            '${business.estimatedDeliveryTime} د',
            style: TextStyle(
              color: colors.onSurfaceVariant,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// QUANTITY
// ============================================================

class _QuantityCard extends StatelessWidget {
  const _QuantityCard({
    required this.quantity,
    required this.onDecrease,
    required this.onIncrease,
  });

  final int quantity;

  final VoidCallback onDecrease;
  final VoidCallback onIncrease;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(Icons.shopping_bag_outlined, color: colors.primary),
          ),
          const SizedBox(width: 11),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('الكمية', style: TextStyle(fontWeight: FontWeight.w900)),
                SizedBox(height: 2),
                Text(
                  'حدد الكمية المطلوبة',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          _QuantityButton(
            icon: Icons.remove_rounded,
            enabled: quantity > 1,
            onTap: onDecrease,
          ),
          SizedBox(
            width: 48,
            child: Center(
              child: Text(
                '$quantity',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          _QuantityButton(
            icon: Icons.add_rounded,
            enabled: true,
            onTap: onIncrease,
          ),
        ],
      ),
    );
  }
}

// ============================================================
// DELIVERY
// ============================================================

class _DeliveryCard extends StatelessWidget {
  const _DeliveryCard({required this.business});

  final Business business;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: colors.outlineVariant),
        borderRadius: BorderRadius.circular(21),
      ),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: colors.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.delivery_dining_rounded, color: colors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'توصيل سريع',
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 3),
                Text(
                  'من ${business.name} إلى عنوانك',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: colors.onSurfaceVariant,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${business.deliveryFee.toStringAsFixed(0)} ج',
            style: const TextStyle(fontWeight: FontWeight.w900),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// AVAILABILITY
// ============================================================

class _AvailabilityCard extends StatelessWidget {
  const _AvailabilityCard({required this.isAvailable});

  final bool isAvailable;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
      decoration: BoxDecoration(
        color: isAvailable
            ? colors.primaryContainer.withOpacity(.45)
            : colors.errorContainer.withOpacity(.5),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(
            isAvailable ? Icons.check_circle_rounded : Icons.cancel_rounded,
            size: 20,
            color: isAvailable ? colors.primary : colors.error,
          ),
          const SizedBox(width: 9),
          Text(
            isAvailable ? 'المنتج متاح للطلب الآن' : 'المنتج غير متاح حاليًا',
            style: TextStyle(
              color: isAvailable ? colors.primary : colors.error,
              fontWeight: FontWeight.w800,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// SECTION TITLE
// ============================================================

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
    );
  }
}

// ============================================================
// BOTTOM BAR
// ============================================================

class _ProductBottomBar extends StatelessWidget {
  const _ProductBottomBar({
    required this.product,
    required this.total,
    required this.quantity,
    required this.onAddToCart,
  });

  final Product product;
  final double total;
  final int quantity;
  final VoidCallback onAddToCart;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 11, 16, 14),
        decoration: BoxDecoration(
          color: colors.surface,
          boxShadow: [
            BoxShadow(
              blurRadius: 25,
              offset: const Offset(0, -7),
              color: Colors.black.withOpacity(.08),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 82,
              height: 56,
              decoration: BoxDecoration(
                color: colors.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(17),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$quantity قطعة',
                    style: TextStyle(
                      color: colors.onSurfaceVariant,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${total.toStringAsFixed(0)} ج',
                    style: TextStyle(
                      color: colors.primary,
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: FilledButton(
                onPressed: product.isAvailable ? onAddToCart : null,
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(17),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shopping_cart_outlined, size: 21),
                    SizedBox(width: 8),
                    Text(
                      'أضف للسلة',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// QUANTITY BUTTON
// ============================================================

class _QuantityButton extends StatelessWidget {
  const _QuantityButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Material(
      color: enabled ? colors.primaryContainer : colors.surface,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: enabled ? onTap : null,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(
            icon,
            size: 20,
            color: enabled ? colors.primary : colors.onSurface.withOpacity(.25),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// CIRCLE BUTTON
// ============================================================

class _CircleButton extends StatelessWidget {
  const _CircleButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Material(
        color: Colors.black.withOpacity(.38),
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: const SizedBox(
            width: 44,
            height: 44,
            child: Icon(Icons.arrow_back_rounded, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// PRODUCT IMAGE
// ============================================================

class _ProductHeroImage extends StatelessWidget {
  const _ProductHeroImage({required this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final url = imageUrl?.trim() ?? '';

    if (url.isEmpty) {
      return Container(
        color: colors.surfaceContainerHighest,
        child: Icon(Icons.fastfood_rounded, size: 78, color: colors.primary),
      );
    }

    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      placeholder: (_, __) {
        return Container(
          color: colors.surfaceContainerHighest,
          child: Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: colors.primary,
            ),
          ),
        );
      },
      errorWidget: (_, __, ___) {
        return Container(
          color: colors.surfaceContainerHighest,
          child: Icon(
            Icons.broken_image_outlined,
            size: 45,
            color: colors.onSurfaceVariant,
          ),
        );
      },
    );
  }
}
