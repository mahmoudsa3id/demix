import 'package:demix/core/routing/route_paths.dart';
import 'package:demix/core/theme/app_colors.dart';
import 'package:demix/core/widgets/app_cached_image.dart';
import 'package:demix/features/business/domain/entities/business.dart';
import 'package:demix/features/business/domain/entities/product.dart';
import 'package:demix/features/business/domain/entities/product_category.dart';
import 'package:demix/features/business/presentation/cubit/business_profile_cubit.dart';
import 'package:demix/features/business/presentation/cubit/business_profile_state.dart';
import 'package:demix/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:demix/features/product_ordering/presentation/pages/product_details_page.dart';
import 'package:demix/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

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
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: BlocBuilder<BusinessProfileCubit, BusinessProfileState>(
        builder: (context, state) {
          if (state is BusinessProfileLoading ||
              state is BusinessProfileInitial) {
            return const _ProfileSkeleton();
          }

          if (state is BusinessProfileFailure) {
            return _ErrorView(
              message: state.message,
              onRetry: () {
                context.read<BusinessProfileCubit>().load(widget.businessId);
              },
            );
          }

          if (state is! BusinessProfileLoaded) {
            return const SizedBox.shrink();
          }

          final categories = state.categories;

          final products = selectedCategory == 0 || categories.isEmpty
              ? state.products
              : state.products
                    .where(
                      (product) =>
                          product.categoryId ==
                          categories[selectedCategory - 1].id,
                    )
                    .toList();

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(child: _Hero(business: state.business)),

              SliverToBoxAdapter(
                child: _BusinessInfo(business: state.business),
              ),

              if (categories.isNotEmpty)
                SliverToBoxAdapter(
                  child: _CategorySelector(
                    categories: categories,
                    selectedCategory: selectedCategory,
                    onSelected: (index) {
                      setState(() {
                        selectedCategory = index;
                      });
                    },
                  ),
                ),

              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 130),
                sliver: products.isEmpty
                    ? const SliverToBoxAdapter(child: _EmptyProducts())
                    : SliverList.separated(
                        itemCount: products.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (_, index) {
                          return _ProductTile(
                            product: products[index],
                            business: state.business,
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: const _CartBar(),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.business});

  final Business business;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: 320,
      child: Stack(
        fit: StackFit.expand,
        children: [
          AppCachedImage(imageUrl: business.coverUrl ?? ''),

          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.25, 1],
                colors: [
                  Colors.transparent,
                  AppColors.primary.withOpacity(.90),
                ],
              ),
            ),
          ),

          Positioned(
            top: 50,
            left: 16,
            child: _CircleAction(
              icon: Icons.arrow_back_rounded,
              onTap: () => context.pop(),
            ),
          ),

          Positioned(
            top: 50,
            right: 20,
            child: _CircleAction(
              icon: Icons.favorite_border_rounded,
              onTap: () {},
            ),
          ),

          Positioned(
            left: 18,
            right: 18,
            bottom: 20,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 9,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.secondary,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              business.type == 'cafe' ? 'كافيه' : 'مطعم',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (business.isOpen)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 9,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(.16),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                'مفتوح الآن',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(.92),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      Text(
                        business.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          height: 1.1,
                        ),
                      ),

                      const SizedBox(height: 7),

                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_rounded,
                            size: 16,
                            color: Colors.white70,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              business.address ?? 'توصيل إلى موقعك',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                if (business.logoUrl?.trim().isNotEmpty == true) ...[
                  const SizedBox(width: 12),
                  Container(
                    width: 72,
                    height: 72,
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(.28),
                          blurRadius: 18,
                          offset: const Offset(0, 7),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: AppCachedImage(imageUrl: business.logoUrl ?? ''),
                    ),
                  ),
                ],
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: _InfoCard(
              icon: Icons.star_rounded,
              value: business.rating.toStringAsFixed(1),
              label: '${business.reviewCount} تقييم',
              iconColor: AppColors.secondary,
            ),
          ),

          const SizedBox(width: 9),

          Expanded(
            child: _InfoCard(
              icon: Icons.schedule_rounded,
              value: '${business.estimatedDeliveryTime} د',
              label: 'وقت التوصيل',
              iconColor: AppColors.primary,
            ),
          ),

          const SizedBox(width: 9),

          Expanded(
            child: _InfoCard(
              icon: Icons.delivery_dining_rounded,
              value: '${business.deliveryFee.toStringAsFixed(0)} ج',
              label: 'التوصيل',
              iconColor: AppColors.secondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.iconColor,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 13),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.primary.withOpacity(.08)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(.04),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(.10),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18, color: iconColor),
          ),

          const SizedBox(height: 7),

          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 14,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 2),

          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _CategorySelector extends StatelessWidget {
  const _CategorySelector({
    required this.categories,
    required this.selectedCategory,
    required this.onSelected,
  });

  final List<ProductCategory> categories;
  final int selectedCategory;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: 52,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: categories.length + 1,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, index) {
          final active = selectedCategory == index;

          final title = index == 0
              ? 'الكل'
              : _categoryName(categories[index - 1]);

          return GestureDetector(
            onTap: () => onSelected(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOut,
              padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 11),
              decoration: BoxDecoration(
                color: active ? AppColors.primary : theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: active
                      ? AppColors.primary
                      : AppColors.primary.withOpacity(.10),
                ),
                boxShadow: active
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(.18),
                          blurRadius: 12,
                          offset: const Offset(0, 5),
                        ),
                      ]
                    : null,
              ),
              child: Center(
                child: Text(
                  title,
                  style: TextStyle(
                    color: active ? Colors.white : AppColors.primary,
                    fontSize: 13,
                    fontWeight: active ? FontWeight.w900 : FontWeight.w700,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _categoryName(ProductCategory category) {
    return category.nameAr?.trim().isNotEmpty == true
        ? category.nameAr!
        : category.name;
  }
}

class _ProductTile extends StatelessWidget {
  const _ProductTile({required this.product, required this.business});

  final Product product;
  final Business business;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        splashColor: AppColors.primary.withOpacity(.05),
        highlightColor: AppColors.primary.withOpacity(.025),
        onTap: () => context.push(
          RoutePaths.product,
          extra: ProductDetailsArguments(product: product, business: business),
        ),
        child: Container(
          padding: const EdgeInsets.all(11),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: AppColors.primary.withOpacity(.08)),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(.035),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Hero(
                tag: 'product-image-${product.id}',
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: AppCachedImage(
                    imageUrl: product.imageUrl ?? '',
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: AppColors.secondary,
                        fontWeight: FontWeight.w900,
                        height: 1.15,
                      ),
                    ),

                    if ((product.descriptionAr ?? product.description ?? '')
                        .trim()
                        .isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        (product.descriptionAr ?? product.description)!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          height: 1.35,
                        ),
                      ),
                    ],

                    const SizedBox(height: 9),

                    Row(
                      children: [
                        Text(
                          '${product.price.toStringAsFixed(0)} ج',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                          ),
                        ),

                        const Spacer(),

                        _AddButton(
                          onTap: () {
                            context.read<CartCubit>().addItem(
                              product: product,
                              business: business,
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  const _AddButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primary,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        splashColor: AppColors.secondary.withOpacity(.20),
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(Icons.add_rounded, color: Colors.white, size: 23),
        ),
      ),
    );
  }
}

class _CartBar extends StatelessWidget {
  const _CartBar();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      buildWhen: (previous, current) {
        return previous.items != current.items ||
            previous.subtotal != current.subtotal;
      },
      builder: (context, cart) {
        if (cart.items.isEmpty) {
          return const SizedBox.shrink();
        }

        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 7, 14, 12),
            child: Material(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(20),
              elevation: 7,
              shadowColor: AppColors.primary.withOpacity(.22),
              child: InkWell(
                borderRadius: BorderRadius.circular(20),

                // مهم:
                // السلة Tab داخل الـ ShellRoute
                onTap: () => context.push(RoutePaths.cart),

                splashColor: AppColors.secondary.withOpacity(.15),

                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(.13),
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

                      const SizedBox(width: 11),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'عرض السلة',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${cart.itemCount} قطعة',
                              style: TextStyle(
                                color: Colors.white.withOpacity(.72),
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.secondary,
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: Text(
                          '${cart.subtotal.toStringAsFixed(0)} ج',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),

                      const SizedBox(width: 8),

                      Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(.12),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.white,
                          size: 14,
                        ),
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
}

class _CircleAction extends StatelessWidget {
  const _CircleAction({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primary.withOpacity(.70),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        splashColor: AppColors.secondary.withOpacity(.18),
        child: SizedBox(width: 44, height: 44, child: Icon(icon)),
      ),
    );
  }
}

class _EmptyProducts extends StatelessWidget {
  const _EmptyProducts();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 70, 20, 40),
      alignment: Alignment.center,
      child: Column(
        children: [
          Container(
            width: 82,
            height: 82,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(.07),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.restaurant_menu_rounded,
              size: 40,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(height: 16),

          Text(
            'مفيش منتجات متاحة حاليًا',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 17,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 7),

          Text(
            'جرب تختار تصنيف تاني أو ارجع بعد شوية.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileSkeleton extends StatelessWidget {
  const _ProfileSkeleton();

  @override
  Widget build(BuildContext context) {
    final surface = Theme.of(context).colorScheme.surface;
    final soft = AppColors.primary.withOpacity(.07);

    return Scaffold(
      backgroundColor: surface,
      body: Column(
        children: [
          Container(height: 250, color: soft),

          const SizedBox(height: 18),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: List.generate(3, (index) {
                return Expanded(
                  child: Container(
                    height: 88,
                    margin: EdgeInsets.only(right: index == 2 ? 0 : 9),
                    decoration: BoxDecoration(
                      color: soft,
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                );
              }),
            ),
          ),

          const SizedBox(height: 18),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: List.generate(
                4,
                (_) => Container(
                  height: 100,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: soft,
                    borderRadius: BorderRadius.circular(22),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 82,
              height: 82,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(.07),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.cloud_off_rounded,
                size: 40,
                color: AppColors.primary,
              ),
            ),

            const SizedBox(height: 18),

            Text(
              'حصلت مشكلة',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 19,
                fontWeight: FontWeight.w900,
              ),
            ),

            const SizedBox(height: 7),

            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 18),

            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 13,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 19),
              label: const Text(
                'حاول مرة أخرى',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
