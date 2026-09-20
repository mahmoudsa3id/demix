import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:demix/core/routing/route_paths.dart';
import 'package:demix/core/theme/app_colors.dart';
import 'package:demix/features/business/domain/entities/business.dart';
import 'package:demix/features/business/domain/entities/product.dart';
import 'package:demix/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

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

class _ProductDetailsPageState extends State<ProductDetailsPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entryController;

  int _quantity = 1;
  bool _addingToCart = false;

  Product get _product => widget.arguments.product;
  Business get _business => widget.arguments.business;

  double get _total => _product.price * _quantity;

  @override
  void initState() {
    super.initState();

    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _entryController.forward();
      }
    });
  }

  @override
  void dispose() {
    _entryController.dispose();
    super.dispose();
  }

  Animation<Offset> _slide(double begin) {
    return Tween<Offset>(begin: Offset(0, begin), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.25, 1, curve: Curves.easeOutCubic),
      ),
    );
  }

  Animation<double> _fade() {
    return CurvedAnimation(
      parent: _entryController,
      curve: const Interval(0.15, 1, curve: Curves.easeOut),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F9),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildHeroAppBar(context),

          SliverToBoxAdapter(
            child: AnimatedBuilder(
              animation: _entryController,
              builder: (_, child) {
                return FadeTransition(
                  opacity: _fade(),
                  child: SlideTransition(position: _slide(.08), child: child),
                );
              },
              child: _buildContent(theme),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _ProductBottomBar(
        product: _product,
        total: _total,
        quantity: _quantity,
        addingToCart: _addingToCart,
        onAddToCart: _addToCart,
      ),
    );
  }

  SliverAppBar _buildHeroAppBar(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    final heroSize = width.clamp(320.0, 500.0) * .60;

    return SliverAppBar(
      expandedHeight: 455,
      pinned: true,
      stretch: true,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: const Color(0xFFF7F7F9),
      surfaceTintColor: Colors.transparent,
      leading: Padding(
        padding: const EdgeInsets.all(7),
        child: _GlassCircleButton(
          icon: Icons.arrow_back_rounded,
          onTap: () => context.pop(),
        ),
      ),
      actions: [
        BlocBuilder<CartCubit, CartState>(
          buildWhen: (previous, current) => previous.items != current.items,
          builder: (context, state) {
            final count = state.itemCount;

            return Padding(
              padding: const EdgeInsets.only(right: 10, top: 7, bottom: 7),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  _GlassCircleButton(
                    icon: Icons.shopping_bag_outlined,
                    onTap: () {
                      context.push(RoutePaths.cart);
                    },
                  ),
                  if (count > 0)
                    Positioned(
                      top: -2,
                      right: -2,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        transitionBuilder: (child, animation) {
                          return ScaleTransition(
                            scale: animation,
                            child: child,
                          );
                        },
                        child: Container(
                          key: ValueKey(count),
                          constraints: const BoxConstraints(
                            minWidth: 20,
                            minHeight: 20,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            color: AppColors.secondary,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: Center(
                            child: Text(
                              '$count',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        stretchModes: const [
          StretchMode.zoomBackground,
          StretchMode.blurBackground,
        ],
        background: _ProductHero(
          product: _product,
          business: _business,
          productSize: heroSize,
        ),
      ),
    );
  }

  Widget _buildContent(ThemeData theme) {
    final description = (_product.descriptionAr ?? _product.description ?? '')
        .trim();

    return Container(
      margin: const EdgeInsets.only(top: 0),
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 155),
      decoration: const BoxDecoration(
        color: Color(0xFFF7F7F9),
        borderRadius: BorderRadius.vertical(top: Radius.circular(34)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),

          const SizedBox(height: 24),

          _AnimatedProductHeader(product: _product),

          const SizedBox(height: 14),

          _BusinessIdentity(business: _business),

          const SizedBox(height: 24),

          if (description.isNotEmpty)
            _InfoSection(
              title: 'عن المنتج',
              icon: Icons.auto_awesome_rounded,
              child: Text(
                description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF686873),
                  fontSize: 13,
                  height: 1.8,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

          if (description.isNotEmpty) const SizedBox(height: 22),

          _InfoSection(
            title: 'الكمية',
            icon: Icons.shopping_bag_outlined,
            child: _QuantitySelector(
              quantity: _quantity,
              onDecrease: _decreaseQuantity,
              onIncrease: _increaseQuantity,
            ),
          ),

          const SizedBox(height: 22),

          _DeliveryInfo(business: _business),

          const SizedBox(height: 14),

          _AvailabilityBanner(isAvailable: _product.isAvailable),
        ],
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
    if (_quantity >= 99) return;

    setState(() {
      _quantity++;
    });
  }

  Future<void> _addToCart() async {
    if (!_product.isAvailable || _addingToCart) return;

    setState(() {
      _addingToCart = true;
    });

    try {
      await Future<void>.delayed(const Duration(milliseconds: 350));

      if (!mounted) return;

      context.read<CartCubit>().addItem(
        product: _product,
        business: _business,
        quantity: _quantity,
      );

      if (!mounted) return;

      setState(() {
        _addingToCart = false;
      });

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 100),
            elevation: 0,
            backgroundColor: const Color(0xFF1F1F25),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            content: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 19,
                  ),
                ),
                const SizedBox(width: 11),
                const Expanded(
                  child: Text(
                    'تمت إضافة المنتج إلى السلة',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    context.push(RoutePaths.cart);
                  },
                  child: const Text(
                    'السلة',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _addingToCart = false;
      });

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red.shade700,
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 100),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            content: Text(
              e.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        );
    }
  }
}

// ============================================================
// HERO
// ============================================================

class _ProductHero extends StatelessWidget {
  const _ProductHero({
    required this.product,
    required this.business,
    required this.productSize,
  });

  final Product product;
  final Business business;
  final double productSize;

  @override
  Widget build(BuildContext context) {
    final backgroundImage = _validUrl(business.coverUrl)
        ? business.coverUrl!
        : product.imageUrl;

    return Stack(
      fit: StackFit.expand,
      children: [
        CachedNetworkImage(
          imageUrl: backgroundImage ?? '',
          fit: BoxFit.cover,
          color: Colors.black.withOpacity(.28),
          colorBlendMode: BlendMode.darken,
          errorWidget: (_, __, ___) {
            return Container(color: const Color(0xFFEFEFF3));
          },
        ),

        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(color: Colors.black.withOpacity(.20)),
        ),

        Positioned(
          left: -100,
          right: -100,
          top: 30,
          bottom: 0,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(.08),
                  Colors.black.withOpacity(.45),
                ],
              ),
            ),
          ),
        ),

        Positioned.fill(
          child: SafeArea(
            bottom: false,
            child: Column(
              children: [
                const Spacer(),

                TweenAnimationBuilder<double>(
                  tween: Tween(begin: .88, end: 1),
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeOutBack,
                  builder: (_, scale, child) {
                    return Transform.scale(scale: scale, child: child);
                  },
                  child: Hero(
                    tag: 'product-image-${product.id}',
                    child: _ProductImageCard(
                      imageUrl: product.imageUrl,
                      size: productSize,
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                _BusinessHeroMeta(business: business),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ],
    );
  }

  bool _validUrl(String? url) {
    return url != null && url.trim().isNotEmpty && url.startsWith('http');
  }
}

class _ProductImageCard extends StatelessWidget {
  const _ProductImageCard({required this.imageUrl, required this.size});

  final String? imageUrl;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.96),
        borderRadius: BorderRadius.circular(34),
        border: Border.all(color: Colors.white.withOpacity(.8), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.25),
            blurRadius: 35,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: _NetworkImage(imageUrl: imageUrl, fit: BoxFit.cover),
      ),
    );
  }
}

// ============================================================
// BUSINESS HERO
// ============================================================

class _BusinessHeroMeta extends StatelessWidget {
  const _BusinessHeroMeta({required this.business});

  final Business business;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _BusinessLogo(
          imageUrl: business.logoUrl,
          size: 50,
          borderColor: Colors.white.withOpacity(.85),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              business.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(
                  Icons.star_rounded,
                  color: Color(0xFFFFC857),
                  size: 15,
                ),
                const SizedBox(width: 3),
                Text(
                  business.rating.toStringAsFixed(1),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.65),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${business.estimatedDeliveryTime} دقيقة',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

// ============================================================
// PRODUCT HEADER
// ============================================================

class _AnimatedProductHeader extends StatelessWidget {
  const _AnimatedProductHeader({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            product.name,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF17171C),
              fontSize: 27,
              height: 1.1,
              fontWeight: FontWeight.w900,
              letterSpacing: -.6,
            ),
          ),
        ),
        const SizedBox(width: 14),
        _PriceBadge(price: product.price),
      ],
    );
  }
}

class _PriceBadge extends StatelessWidget {
  const _PriceBadge({required this.price});

  final double price;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
        ),
        borderRadius: BorderRadius.circular(17),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(.20),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Text(
        '${price.toStringAsFixed(0)} ج',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

// ============================================================
// BUSINESS IDENTITY
// ============================================================

class _BusinessIdentity extends StatelessWidget {
  const _BusinessIdentity({required this.business});

  final Business business;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.black.withOpacity(.04)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.035),
            blurRadius: 22,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: Row(
        children: [
          _BusinessLogo(imageUrl: business.logoUrl, size: 52),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  business.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF1D1D23),
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    _MiniInfo(
                      icon: Icons.star_rounded,
                      text: business.rating.toStringAsFixed(1),
                    ),
                    const SizedBox(width: 12),
                    _MiniInfo(
                      icon: Icons.schedule_rounded,
                      text: '${business.estimatedDeliveryTime} د',
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_left_rounded, color: Colors.black26),
        ],
      ),
    );
  }
}

class _MiniInfo extends StatelessWidget {
  const _MiniInfo({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.primary),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            color: Color(0xFF777780),
            fontSize: 10,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

// ============================================================
// INFO SECTION
// ============================================================

class _InfoSection extends StatelessWidget {
  const _InfoSection({
    required this.title,
    required this.icon,
    required this.child,
  });

  final String title;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withOpacity(.12),
                    AppColors.secondary.withOpacity(.12),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 15, color: AppColors.primary),
            ),
            const SizedBox(width: 9),
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFF1B1B20),
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
        const SizedBox(height: 11),
        child,
      ],
    );
  }
}

// ============================================================
// QUANTITY
// ============================================================

class _QuantitySelector extends StatelessWidget {
  const _QuantitySelector({
    required this.quantity,
    required this.onDecrease,
    required this.onIncrease,
  });

  final int quantity;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.black.withOpacity(.05)),
      ),
      child: Row(
        children: [
          _QuantityButton(
            icon: Icons.remove_rounded,
            enabled: quantity > 1,
            onTap: onDecrease,
          ),

          Expanded(
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                transitionBuilder: (child, animation) {
                  return ScaleTransition(scale: animation, child: child);
                },
                child: Text(
                  '$quantity',
                  key: ValueKey(quantity),
                  style: const TextStyle(
                    color: Color(0xFF17171C),
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
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
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        gradient: enabled
            ? LinearGradient(colors: [AppColors.primary, AppColors.secondary])
            : null,
        color: enabled ? null : const Color(0xFFF1F1F4),
        shape: BoxShape.circle,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled ? onTap : null,
          customBorder: const CircleBorder(),
          child: Icon(
            icon,
            size: 20,
            color: enabled ? Colors.white : Colors.black26,
          ),
        ),
      ),
    );
  }
}

// ============================================================
// DELIVERY
// ============================================================

class _DeliveryInfo extends StatelessWidget {
  const _DeliveryInfo({required this.business});

  final Business business;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF17171C),
        borderRadius: BorderRadius.circular(23),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.delivery_dining_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'التوصيل',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${business.estimatedDeliveryTime} دقيقة تقريبًا',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'رسوم التوصيل',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${business.deliveryFee.toStringAsFixed(0)} ج',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
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

// ============================================================
// AVAILABILITY
// ============================================================

class _AvailabilityBanner extends StatelessWidget {
  const _AvailabilityBanner({required this.isAvailable});

  final bool isAvailable;

  @override
  Widget build(BuildContext context) {
    final color = isAvailable
        ? const Color(0xFF15A86B)
        : const Color(0xFFE05252);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
      decoration: BoxDecoration(
        color: color.withOpacity(.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withOpacity(.12)),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: color.withOpacity(.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isAvailable ? Icons.check_rounded : Icons.close_rounded,
              size: 16,
              color: color,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              isAvailable ? 'المنتج متاح للطلب الآن' : 'المنتج غير متاح حاليًا',
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
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
    required this.addingToCart,
    required this.onAddToCart,
  });

  final Product product;
  final double total;
  final int quantity;
  final bool addingToCart;
  final VoidCallback onAddToCart;

  @override
  Widget build(BuildContext context) {
    final isAvailable = product.isAvailable;

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F7F9),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.09),
              blurRadius: 30,
              offset: const Offset(0, -10),
            ),
          ],
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 92,
              height: 58,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$quantity قطعة',
                    style: const TextStyle(
                      color: Color(0xFF85858E),
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Text(
                      '${total.toStringAsFixed(0)} ج',
                      key: ValueKey(total),
                      style: const TextStyle(
                        color: Color(0xFF17171C),
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: _AddToCartButton(
                enabled: isAvailable,
                loading: addingToCart,
                onTap: onAddToCart,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddToCartButton extends StatelessWidget {
  const _AddToCartButton({
    required this.enabled,
    required this.loading,
    required this.onTap,
  });

  final bool enabled;
  final bool loading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      height: 58,
      decoration: BoxDecoration(
        gradient: enabled
            ? LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [AppColors.primary, AppColors.secondary],
              )
            : null,
        color: enabled ? null : const Color(0xFFDDDDE2),
        borderRadius: BorderRadius.circular(18),
        boxShadow: enabled
            ? [
                BoxShadow(
                  color: AppColors.primary.withOpacity(.20),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled && !loading ? onTap : null,
          borderRadius: BorderRadius.circular(18),
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              child: loading
                  ? const SizedBox(
                      key: ValueKey('loading'),
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.4,
                        color: Colors.white,
                      ),
                    )
                  : Row(
                      key: const ValueKey('button'),
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.shopping_bag_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 9),
                        Text(
                          enabled ? 'أضف للسلة' : 'غير متاح',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                          ),
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

// ============================================================
// BUSINESS LOGO
// ============================================================

class _BusinessLogo extends StatelessWidget {
  const _BusinessLogo({
    required this.imageUrl,
    required this.size,
    this.borderColor,
  });

  final String? imageUrl;
  final double size;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor ?? Colors.black.withOpacity(.06),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.10),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipOval(
        child: _NetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          fallbackIcon: Icons.storefront_rounded,
        ),
      ),
    );
  }
}

// ============================================================
// NETWORK IMAGE
// ============================================================

class _NetworkImage extends StatelessWidget {
  const _NetworkImage({
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.fallbackIcon = Icons.fastfood_rounded,
  });

  final String? imageUrl;
  final BoxFit fit;
  final IconData fallbackIcon;

  @override
  Widget build(BuildContext context) {
    final url = imageUrl?.trim() ?? '';

    if (url.isEmpty) {
      return Container(
        color: const Color(0xFFF0F0F3),
        child: Icon(
          fallbackIcon,
          size: 40,
          color: AppColors.primary.withOpacity(.45),
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: url,
      fit: fit,
      placeholder: (_, __) {
        return Container(
          color: const Color(0xFFF0F0F3),
          child: const Center(
            child: SizedBox(
              width: 23,
              height: 23,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        );
      },
      errorWidget: (_, __, ___) {
        return Container(
          color: const Color(0xFFF0F0F3),
          child: Icon(
            fallbackIcon,
            size: 40,
            color: AppColors.primary.withOpacity(.4),
          ),
        );
      },
    );
  }
}

// ============================================================
// GLASS BUTTON
// ============================================================

class _GlassCircleButton extends StatelessWidget {
  const _GlassCircleButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Material(
          color: Colors.black.withOpacity(.28),
          child: InkWell(
            onTap: onTap,
            customBorder: const CircleBorder(),
            child: SizedBox(
              width: 44,
              height: 44,
              child: Icon(icon, color: Colors.white, size: 21),
            ),
          ),
        ),
      ),
    );
  }
}
