import 'package:cached_network_image/cached_network_image.dart';
import 'package:demix/core/routing/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:demix/features/business/domain/entities/business.dart';
import 'package:demix/features/business/domain/entities/product_category.dart';
import 'package:demix/features/business/domain/entities/product.dart';
import 'package:demix/features/business/presentation/cubit/business_profile_cubit.dart';
import 'package:demix/features/business/presentation/cubit/business_profile_state.dart';
import 'package:demix/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:demix/features/product_ordering/presentation/pages/product_details_page.dart';
import 'package:demix/main.dart';

class BusinessProfilePage extends StatelessWidget {
  const BusinessProfilePage({super.key, required this.businessId});
  final String businessId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<BusinessProfileCubit>()..load(businessId),
      child: _BusinessProfileView(businessId: businessId),
    );
  }
}

class _BusinessProfileView extends StatefulWidget {
  const _BusinessProfileView({required this.businessId});
  final String businessId;
  @override
  State<_BusinessProfileView> createState() => _BusinessProfileViewState();
}

class _BusinessProfileViewState extends State<_BusinessProfileView> {
  int selectedCategory = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: BlocBuilder<BusinessProfileCubit, BusinessProfileState>(
        builder: (context, state) {
          if (state is BusinessProfileLoading ||
              state is BusinessProfileInitial)
            return const _ProfileSkeleton();
          if (state is BusinessProfileFailure)
            return _ErrorView(
              message: state.message,
              onRetry: () =>
                  context.read<BusinessProfileCubit>().load(widget.businessId),
            );
          if (state is! BusinessProfileLoaded) return const SizedBox.shrink();
          final categories = state.categories;
          final products = selectedCategory == 0 || categories.isEmpty
              ? state.products
              : state.products
                    .where(
                      (p) =>
                          p.categoryId == categories[selectedCategory - 1].id,
                    )
                    .toList();
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _Hero(business: state.business)),
              SliverToBoxAdapter(
                child: _BusinessInfo(business: state.business),
              ),
              if (categories.isNotEmpty)
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 54,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length + 1,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (_, index) {
                        final active = selectedCategory == index;
                        return ChoiceChip(
                          selected: active,
                          label: Text(
                            index == 0
                                ? 'الكل'
                                : _categoryName(categories[index - 1]),
                          ),
                          onSelected: (_) =>
                              setState(() => selectedCategory = index),
                          showCheckmark: false,
                          selectedColor: Theme.of(context).colorScheme.primary,
                          labelStyle: TextStyle(
                            color: active
                                ? Colors.white
                                : Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.w800,
                          ),
                          side: BorderSide.none,
                        );
                      },
                    ),
                  ),
                ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 120),
                sliver: products.isEmpty
                    ? const SliverToBoxAdapter(child: _EmptyProducts())
                    : SliverList.separated(
                        itemCount: products.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (_, index) => _ProductTile(
                          product: products[index],
                          business: state.business,
                        ),
                      ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: const _CartBar(),
    );
  }

  String _categoryName(ProductCategory category) =>
      category.nameAr?.trim().isNotEmpty == true
      ? category.nameAr!
      : category.name;
}

class _Hero extends StatelessWidget {
  const _Hero({required this.business});
  final Business business;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 300,
      child: Stack(
        fit: StackFit.expand,
        children: [
          _Image(url: business.coverUrl),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(.12),
                  Colors.black.withOpacity(.78),
                ],
              ),
            ),
          ),
          Positioned(
            top: 52,
            left: 18,
            child: _CircleAction(
              icon: Icons.arrow_back_rounded,
              onTap: () => context.pop(),
            ),
          ),
          Positioned(
            top: 52,
            right: 18,
            child: _CircleAction(
              icon: Icons.favorite_border_rounded,
              onTap: () {},
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 22,
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
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        business.address ?? 'توصيل إلى موقعك',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                if (business.logoUrl?.isNotEmpty == true)
                  Container(
                    width: 64,
                    height: 64,
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(child: _Image(url: business.logoUrl)),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BusinessInfo extends StatelessWidget {
  const _BusinessInfo({required this.business});
  final Business business;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 12),
      child: Row(
        children: [
          _InfoPill(
            icon: Icons.star_rounded,
            value: business.rating.toStringAsFixed(1),
            label: '${business.reviewCount} تقييم',
          ),
          const SizedBox(width: 8),
          _InfoPill(
            icon: Icons.schedule_rounded,
            value: '${business.estimatedDeliveryTime} د',
            label: 'التوصيل',
          ),
          const SizedBox(width: 8),
          _InfoPill(
            icon: Icons.delivery_dining_rounded,
            value: '${business.deliveryFee.toStringAsFixed(0)} ج',
            label: 'التوصيل',
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              business.isOpen ? 'مفتوح' : 'مغلق',
              textAlign: TextAlign.center,
              style: theme.textTheme.labelMedium?.copyWith(
                color: business.isOpen ? Colors.green : Colors.red,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({
    required this.icon,
    required this.value,
    required this.label,
  });
  final IconData icon;
  final String value;
  final String label;
  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w900)),
          Text(label, style: Theme.of(context).textTheme.labelSmall),
        ],
      ),
    ),
  );
}

class _ProductTile extends StatelessWidget {
  const _ProductTile({required this.product, required this.business});
  final Product product;
  final Business business;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: () => context.push(
          RoutePaths.product,
          extra: ProductDetailsArguments(product: product, business: business),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              SizedBox(
                width: 106,
                height: 106,
                child: _Image(url: product.imageUrl, radius: 18),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    if ((product.descriptionAr ?? product.description ?? '')
                        .trim()
                        .isNotEmpty) ...[
                      const SizedBox(height: 5),
                      Text(
                        (product.descriptionAr ?? product.description)!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          height: 1.3,
                        ),
                      ),
                    ],
                    const SizedBox(height: 9),
                    Text(
                      '${product.price.toStringAsFixed(0)} ج',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              Material(
                color: theme.colorScheme.primary,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () => context.read<CartCubit>().addItem(
                    product: product,
                    business: business,
                  ),
                  child: const SizedBox(
                    width: 42,
                    height: 42,
                    child: Icon(Icons.add_rounded, color: Colors.white),
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

class _CartBar extends StatelessWidget {
  const _CartBar();
  @override
  Widget build(BuildContext context) => BlocBuilder<CartCubit, CartState>(
    builder: (context, cart) {
      if (cart.items.isEmpty) return const SizedBox.shrink();
      final theme = Theme.of(context);
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Material(
            color: theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(22),
            child: InkWell(
              borderRadius: BorderRadius.circular(22),
              onTap: () => context.push(RoutePaths.cart),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 14,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.18),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${cart.itemCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'عرض السلة',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Text(
                      '${cart.subtotal.toStringAsFixed(0)} ج',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.white,
                      size: 15,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}

class _CircleAction extends StatelessWidget {
  const _CircleAction({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Material(
    color: Colors.black.withOpacity(.28),
    shape: const CircleBorder(),
    child: InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: SizedBox(
        width: 46,
        height: 46,
        child: Icon(icon, color: Colors.white),
      ),
    ),
  );
}

class _Image extends StatelessWidget {
  const _Image({required this.url, this.radius = 0});
  final String? url;
  final double radius;
  @override
  Widget build(BuildContext context) {
    final u = url?.trim() ?? '';
    final child = u.isEmpty
        ? Container(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Icon(
              Icons.fastfood_rounded,
              color: Theme.of(context).colorScheme.primary,
              size: 34,
            ),
          )
        : CachedNetworkImage(
            imageUrl: u,
            fit: BoxFit.cover,
            placeholder: (_, __) => Container(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
            ),
            errorWidget: (_, __, ___) => Container(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: const Icon(Icons.broken_image_outlined),
            ),
          );
    return ClipRRect(borderRadius: BorderRadius.circular(radius), child: child);
  }
}

class _EmptyProducts extends StatelessWidget {
  const _EmptyProducts();
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 60),
    child: Column(
      children: [
        Icon(
          Icons.restaurant_menu_rounded,
          size: 52,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 12),
        const Text('مفيش منتجات متاحة حاليًا'),
      ],
    ),
  );
}

class _ProfileSkeleton extends StatelessWidget {
  const _ProfileSkeleton();
  @override
  Widget build(BuildContext context) => Scaffold(
    body: Column(
      children: [
        Container(
          height: 200,
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
        ),
        const SizedBox(height: 18),
        Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: List.generate(
              5,
              (_) => Container(
                height: 90,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;
  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.cloud_off_rounded,
            size: 56,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 14),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          FilledButton(onPressed: onRetry, child: const Text('حاول مرة أخرى')),
        ],
      ),
    ),
  );
}
