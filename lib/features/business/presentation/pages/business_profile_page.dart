import 'dart:async';
import 'dart:ui';

import 'package:demix/core/di/injection.dart';
import 'package:demix/core/routing/route_paths.dart';
import 'package:demix/core/theme/app_colors.dart';
import 'package:demix/core/utils/helper/business_hours_utils.dart';
import 'package:demix/core/widgets/app_background_page.dart';
import 'package:demix/core/widgets/app_cached_image.dart';

import 'package:demix/features/business/domain/entities/business.dart';
import 'package:demix/features/business/domain/entities/product.dart';
import 'package:demix/features/business/domain/entities/product_category.dart';

import 'package:demix/features/business/presentation/cubit/business_profile_cubit.dart';
import 'package:demix/features/business/presentation/cubit/business_profile_state.dart';

import 'package:demix/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:demix/features/favorite/domain/entities/favourite_entity.dart';
import 'package:demix/features/favorite/presentation/cubit/favorites_cubit.dart';

import 'package:demix/features/product_ordering/presentation/pages/product_details_page.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class BusinessProfilePage extends StatelessWidget {
  const BusinessProfilePage({super.key, required this.businessId});

  final String businessId;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return MultiBlocProvider(
      providers: [
        BlocProvider<BusinessProfileCubit>(
          create: (_) => getIt<BusinessProfileCubit>()..load(businessId),
        ),
        if (user != null)
          BlocProvider<FavoritesCubit>(
            create: (_) => getIt<FavoritesCubit>(param1: user.uid)..load(),
          ),
      ],
      child: _BusinessProfileView(businessId: businessId),
    );
  }
}

// ============================================================================
// BUSINESS PROFILE VIEW
// ============================================================================

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
      backgroundColor: const Color(0xFFF8F8FA),
      extendBody: true,
      body: AppPageBackground(
        child: BlocBuilder<BusinessProfileCubit, BusinessProfileState>(
          builder: (context, state) {
            // =================================================================
            // LOADING
            // =================================================================

            if (state is BusinessProfileInitial ||
                state is BusinessProfileLoading) {
              return const _ProfileSkeleton();
            }

            // =================================================================
            // ERROR
            // =================================================================

            if (state is BusinessProfileFailure) {
              return _ErrorView(
                message: state.message,
                onRetry: () {
                  context.read<BusinessProfileCubit>().load(widget.businessId);
                },
              );
            }

            // =================================================================
            // UNKNOWN
            // =================================================================

            if (state is! BusinessProfileLoaded) {
              return const SizedBox.shrink();
            }

            // =================================================================
            // DATA
            // =================================================================

            final business = state.business;
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

            final selectedTitle = selectedCategory == 0
                ? 'كل الأصناف'
                : _categoryName(categories[selectedCategory - 1]);

            // =================================================================
            // PAGE
            // =================================================================

            return CustomScrollView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              slivers: [
                // =============================================================
                // HERO
                // =============================================================
                SliverToBoxAdapter(child: _EditorialHero(business: business)),

                // =============================================================
                // BUSINESS INTRO
                // =============================================================
                SliverToBoxAdapter(child: _BusinessIntro(business: business)),

                // =============================================================
                // STICKY CATEGORY NAVIGATION
                // =============================================================
                if (categories.isNotEmpty)
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _EditorialCategoryHeaderDelegate(
                      child: _EditorialCategoryNavigator(
                        categories: categories,
                        selectedCategory: selectedCategory,
                        onSelected: (index) {
                          if (index == selectedCategory) {
                            return;
                          }

                          setState(() {
                            selectedCategory = index;
                          });
                        },
                      ),
                    ),
                  ),

                // =============================================================
                // CATEGORY TITLE
                // =============================================================
                SliverToBoxAdapter(
                  child: _CurrentCategoryHeading(
                    title: selectedTitle,
                    count: products.length,
                    index: selectedCategory,
                    total: categories.length + 1,
                  ),
                ),

                // =============================================================
                // PRODUCTS
                // =============================================================
                if (products.isEmpty)
                  const SliverToBoxAdapter(child: _EmptyProducts())
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(18, 0, 18, 150),
                    sliver: SliverList.separated(
                      itemCount: products.length,
                      separatorBuilder: (_, __) {
                        return const SizedBox(height: 4);
                      },
                      itemBuilder: (context, index) {
                        return _EditorialProductItem(
                          key: ValueKey(
                            '${products[index].id}-$selectedCategory',
                          ),
                          product: products[index],
                          business: business,
                          index: index,
                        );
                      },
                    ),
                  ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: const _CartBar(),
    );
  }

  static String _categoryName(ProductCategory category) {
    if (category.nameAr?.trim().isNotEmpty == true) {
      return category.nameAr!;
    }

    return category.name;
  }
}

// ============================================================================
// HERO
// ============================================================================

class _EditorialHero extends StatelessWidget {
  const _EditorialHero({required this.business});

  final Business business;

  @override
  Widget build(BuildContext context) {
    final coverUrl = business.coverUrl?.trim() ?? '';
    final logoUrl = business.logoUrl?.trim() ?? '';

    final isCafe = business.type.trim().toLowerCase() == 'cafe';

    return SizedBox(
      height: 360,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // ===================================================================
          // COVER
          // ===================================================================
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(42),
              bottomRight: Radius.circular(42),
            ),
            child: coverUrl.isNotEmpty
                ? AppCachedImage(imageUrl: coverUrl, fit: BoxFit.cover)
                : DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [AppColors.primary, AppColors.secondary],
                      ),
                    ),
                  ),
          ),

          // ===================================================================
          // DARK OVERLAY
          // ===================================================================
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.0, 0.35, 0.65, 1.0],
                  colors: [
                    Colors.black.withValues(alpha: .08),
                    Colors.transparent,
                    Colors.black.withValues(alpha: .28),
                    Colors.black.withValues(alpha: .78),
                  ],
                ),
              ),
            ),
          ),

          // ===================================================================
          // BRAND GLOW
          // ===================================================================
          Positioned(
            top: -90,
            right: -100,
            child: IgnorePointer(
              child: Container(
                width: 230,
                height: 230,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.secondary.withValues(alpha: .22),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ===================================================================
          // LIVE STATUS
          // ===================================================================
          Positioned(
            top: MediaQuery.of(context).padding.top + 14,
            right: 16,
            child: _LiveOpenStatus(business: business),
          ),

          // ===================================================================
          // FAVORITE / BACK
          // ===================================================================
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            left: 16,
            child: _HeroActions(business: business),
          ),

          // ===================================================================
          // BUSINESS CONTENT
          // ===================================================================
          Positioned(
            left: 18,
            right: 18,
            bottom: 22,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // =============================================================
                // TEXT
                // =============================================================
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // -------------------------------------------------------
                      // TYPE
                      // -------------------------------------------------------
                      Row(
                        children: [
                          _TypePill(
                            icon: isCafe
                                ? Icons.local_cafe_rounded
                                : Icons.restaurant_rounded,
                            title: isCafe ? 'كافيه' : 'مطعم',
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // -------------------------------------------------------
                      // NAME
                      // -------------------------------------------------------
                      Text(
                        business.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 29,
                          height: 1.0,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -1,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // -------------------------------------------------------
                      // ADDRESS
                      // -------------------------------------------------------
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_rounded,
                            color: Colors.white70,
                            size: 15,
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              business.address?.trim().isNotEmpty == true
                                  ? business.address!
                                  : 'توصيل إلى موقعك',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // =============================================================
                // LOGO
                // =============================================================
                if (logoUrl.isNotEmpty) ...[
                  const SizedBox(width: 15),
                  _HeroLogo(imageUrl: logoUrl),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// HERO ACTIONS
// ============================================================================

class _HeroActions extends StatelessWidget {
  const _HeroActions({required this.business});

  final Business business;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Row(
      children: [
        // =====================================================================
        // BACK
        // =====================================================================
        _HeroCircleButton(
          icon: Icons.arrow_back_ios_new_rounded,
          onTap: () {
            context.pop();
          },
        ),

        if (user != null) ...[
          const SizedBox(width: 8),

          // ===================================================================
          // FAVORITE
          // ===================================================================
          BlocBuilder<FavoritesCubit, FavoritesState>(
            builder: (context, state) {
              final favorite = FavoriteEntity.fromBusiness(business);

              final isFavorite =
                  state is FavoritesLoaded && state.contains(favorite.id);

              return _HeroFavoriteButton(
                isFavorite: isFavorite,
                onTap: () {
                  context.read<FavoritesCubit>().toggle(favorite);
                },
              );
            },
          ),
        ],
      ],
    );
  }
}

// ============================================================================
// LIVE OPEN STATUS
// ============================================================================

class _LiveOpenStatus extends StatefulWidget {
  const _LiveOpenStatus({required this.business});

  final Business business;

  @override
  State<_LiveOpenStatus> createState() => _LiveOpenStatusState();
}

class _LiveOpenStatusState extends State<_LiveOpenStatus> {
  Timer? _timer;

  bool _isOpen = false;

  @override
  void initState() {
    super.initState();

    _refresh();

    _timer = Timer.periodic(const Duration(seconds: 30), (_) {
      _refresh();
    });
  }

  void _refresh() {
    final business = widget.business;

    final result = isBusinessCurrentlyOpen(
      open: business.workingHours?.open,
      close: business.workingHours?.close,
      isManuallyOpen: business.isOpen,
    );

    if (!mounted) {
      return;
    }

    if (_isOpen != result) {
      setState(() {
        _isOpen = result;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _OpenStatusPill(isOpen: _isOpen);
  }
}

// ============================================================================
// OPEN STATUS PILL
// ============================================================================

class _OpenStatusPill extends StatelessWidget {
  const _OpenStatusPill({required this.isOpen});

  final bool isOpen;

  @override
  Widget build(BuildContext context) {
    final statusColor = isOpen
        ? const Color(0xFF2BE18A)
        : const Color(0xFFFF6666);

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: .25),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: .14)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 350),
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: statusColor,
                  boxShadow: [
                    BoxShadow(
                      color: statusColor.withValues(alpha: .55),
                      blurRadius: 9,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 7),
              Text(
                isOpen ? 'مفتوح الآن' : 'مغلق الآن',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
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
// HERO CIRCLE BUTTON
// ============================================================================

class _HeroCircleButton extends StatelessWidget {
  const _HeroCircleButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: .25),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 46,
          height: 46,
          child: Icon(icon, color: Colors.white, size: 17),
        ),
      ),
    );
  }
}

// ============================================================================
// HERO FAVORITE BUTTON
// ============================================================================

class _HeroFavoriteButton extends StatelessWidget {
  const _HeroFavoriteButton({required this.isFavorite, required this.onTap});

  final bool isFavorite;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: .96),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isFavorite
                ? AppColors.secondary.withValues(alpha: .08)
                : Colors.white.withValues(alpha: .96),
            border: Border.all(color: Colors.white),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .10),
                blurRadius: 18,
                offset: const Offset(0, 7),
              ),
            ],
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            transitionBuilder: (child, animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: Icon(
              isFavorite
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              key: ValueKey(isFavorite),
              color: isFavorite ? AppColors.secondary : AppColors.black,
              size: 21,
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// HERO LOGO
// ============================================================================

class _HeroLogo extends StatelessWidget {
  const _HeroLogo({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 850),
      curve: Curves.elasticOut,
      tween: Tween(begin: .75, end: 1),
      builder: (_, scale, child) {
        return Transform.scale(scale: scale, child: child);
      },
      child: Container(
        width: 72,
        height: 72,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(21),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .22),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: AppCachedImage(imageUrl: imageUrl, fit: BoxFit.cover),
        ),
      ),
    );
  }
}

// ============================================================================
// TYPE PILL
// ============================================================================

class _TypePill extends StatelessWidget {
  const _TypePill({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(11),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withValues(alpha: .18),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 13, color: Colors.white),
          const SizedBox(width: 5),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// GLASS TEXT PILL
// ============================================================================

class _GlassTextPill extends StatelessWidget {
  const _GlassTextPill({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(11),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: .20),
            borderRadius: BorderRadius.circular(11),
            border: Border.all(color: Colors.white.withValues(alpha: .12)),
          ),
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 9.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// BUSINESS INTRO
// ============================================================================

class _BusinessIntro extends StatelessWidget {
  const _BusinessIntro({required this.business});

  final Business business;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 23, 20, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // =================================================================
          // LEFT
          // =================================================================
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  business.type.toUpperCase(),
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.8,
                  ),
                ),
                const SizedBox(height: 7),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_rounded,
                      size: 15,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        business.address?.trim().isNotEmpty == true
                            ? business.address!
                            : 'الموقع غير متوفر',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 20),

          // =================================================================
          // RATING
          // =================================================================
          _BusinessRating(
            rating: business.rating,
            reviews: business.reviewCount,
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// BUSINESS RATING
// ============================================================================

class _BusinessRating extends StatelessWidget {
  const _BusinessRating({required this.rating, required this.reviews});

  final double rating;
  final int reviews;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          children: [
            const Icon(Icons.star_rounded, size: 18, color: Color(0xFFFFB300)),
            const SizedBox(width: 3),
            Text(
              rating.toStringAsFixed(1),
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          '$reviews تقييم',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 9,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// CATEGORY HEADER
// ============================================================================

class _EditorialCategoryHeaderDelegate extends SliverPersistentHeaderDelegate {
  const _EditorialCategoryHeaderDelegate({required this.child});

  final Widget child;

  @override
  double get minExtent => 86;

  @override
  double get maxExtent => 86;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      height: 86,
      color: const Color(0xFFF8F8FA).withValues(alpha: .96),
      child: child,
    );
  }

  @override
  bool shouldRebuild(covariant _EditorialCategoryHeaderDelegate oldDelegate) {
    return oldDelegate.child != child;
  }
}

// ============================================================================
// CATEGORY NAVIGATOR
// ============================================================================

class _EditorialCategoryNavigator extends StatefulWidget {
  const _EditorialCategoryNavigator({
    required this.categories,
    required this.selectedCategory,
    required this.onSelected,
  });

  final List<ProductCategory> categories;
  final int selectedCategory;
  final ValueChanged<int> onSelected;

  @override
  State<_EditorialCategoryNavigator> createState() =>
      _EditorialCategoryNavigatorState();
}

class _EditorialCategoryNavigatorState
    extends State<_EditorialCategoryNavigator> {
  final ScrollController _scrollController = ScrollController();

  @override
  void didUpdateWidget(covariant _EditorialCategoryNavigator oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.selectedCategory != widget.selectedCategory) {
      _centerSelected();
    }
  }

  void _centerSelected() {
    if (!_scrollController.hasClients) {
      return;
    }

    final estimatedItemWidth = 112.0;

    final target =
        (widget.selectedCategory * estimatedItemWidth) -
        (MediaQuery.of(context).size.width / 2) +
        estimatedItemWidth / 2;

    final max = _scrollController.position.maxScrollExtent;

    _scrollController.animateTo(
      target.clamp(0, max),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.categories.length + 1;

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 7, 18, 7),
      child: Row(
        children: [
          // =================================================================
          // BIG NUMBER
          // =================================================================
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 330),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, .3),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: SizedBox(
              key: ValueKey(widget.selectedCategory),
              width: 45,
              child: Text(
                (widget.selectedCategory + 1).toString().padLeft(2, '0'),
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1.5,
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          Container(
            width: 1,
            height: 46,
            color: Colors.black.withValues(alpha: .07),
          ),

          const SizedBox(width: 14),

          // =================================================================
          // CATEGORY LIST
          // =================================================================
          Expanded(
            child: SizedBox(
              height: 72,
              child: ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: total,
                itemBuilder: (context, index) {
                  final active = index == widget.selectedCategory;

                  final title = index == 0
                      ? 'الكل'
                      : _categoryName(widget.categories[index - 1]);

                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      widget.onSelected(index);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 320),
                      curve: Curves.easeOutCubic,
                      padding: const EdgeInsetsDirectional.only(end: 25),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOutCubic,
                            style: TextStyle(
                              color: active
                                  ? AppColors.black
                                  : AppColors.textSecondary,
                              fontSize: active ? 15 : 11.5,
                              fontWeight: active
                                  ? FontWeight.w900
                                  : FontWeight.w600,
                              fontFamily: 'cairo',
                              letterSpacing: active ? -.4 : 0,
                            ),
                            child: Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                          const SizedBox(height: 9),

                          AnimatedContainer(
                            duration: const Duration(milliseconds: 320),
                            curve: Curves.easeOutCubic,
                            width: active ? 42 : 0,
                            height: 3,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.primary,
                                  AppColors.secondary,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _categoryName(ProductCategory category) {
    if (category.nameAr?.trim().isNotEmpty == true) {
      return category.nameAr!;
    }

    return category.name;
  }
}

// ============================================================================
// CURRENT CATEGORY HEADING
// ============================================================================

class _CurrentCategoryHeading extends StatelessWidget {
  const _CurrentCategoryHeading({
    required this.title,
    required this.count,
    required this.index,
    required this.total,
  });

  final String title;
  final int count;
  final int index;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // =================================================================
          // TITLE
          // =================================================================
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, .18),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: Column(
                key: ValueKey(title),
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'MENU',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2.4,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // =================================================================
          // COUNT
          // =================================================================
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: Text(
                  '$count',
                  key: ValueKey(count),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Text(
                'صنف',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// PRODUCT ITEM
// ============================================================================

class _EditorialProductItem extends StatefulWidget {
  const _EditorialProductItem({
    super.key,
    required this.product,
    required this.business,
    required this.index,
  });

  final Product product;
  final Business business;
  final int index;

  @override
  State<_EditorialProductItem> createState() => _EditorialProductItemState();
}

class _EditorialProductItemState extends State<_EditorialProductItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 420 + (widget.index * 35)),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final value = Curves.easeOutCubic.transform(_controller.value);

        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: _ProductContent(
        product: widget.product,
        business: widget.business,
        index: widget.index,
      ),
    );
  }
}

// ============================================================================
// PRODUCT CONTENT
// ============================================================================

class _ProductContent extends StatelessWidget {
  const _ProductContent({
    required this.product,
    required this.business,
    required this.index,
  });

  final Product product;
  final Business business;
  final int index;

  @override
  Widget build(BuildContext context) {
    final imageUrl = product.imageUrl?.trim() ?? '';

    final title = product.nameAr?.trim().isNotEmpty == true
        ? product.nameAr!
        : product.name;

    final description = (product.descriptionAr ?? product.description ?? '')
        .trim();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(26),
        onTap: () {
          context.push(
            RoutePaths.product,
            extra: ProductDetailsArguments(
              product: product,
              business: business,
            ),
          );
        },
        splashColor: AppColors.primary.withValues(alpha: .025),
        highlightColor: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // =============================================================
              // IMAGE
              // =============================================================
              Hero(
                tag: 'product-image-${product.id}',
                child: Container(
                  width: 108,
                  height: 108,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F0F3),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(14),
                      bottomLeft: Radius.circular(14),
                      bottomRight: Radius.circular(32),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: .04),
                        blurRadius: 18,
                        offset: const Offset(0, 7),
                      ),
                    ],
                  ),
                  child: imageUrl.isNotEmpty
                      ? AppCachedImage(imageUrl: imageUrl, fit: BoxFit.cover)
                      : Icon(
                          Icons.fastfood_rounded,
                          color: AppColors.textSecondary,
                          size: 30,
                        ),
                ),
              ),

              const SizedBox(width: 15),

              // =============================================================
              // INFO
              // =============================================================
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.07,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -.45,
                      ),
                    ),

                    if (description.isNotEmpty) ...[
                      const SizedBox(height: 7),
                      Text(
                        description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 10.5,
                          height: 1.4,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],

                    const SizedBox(height: 12),

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

                        const SizedBox(width: 8),

                        if (product.isAvailable)
                          Container(
                            width: 5,
                            height: 5,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.secondary,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              // =============================================================
              // ADD
              // =============================================================
              _EditorialAddButton(product: product, business: business),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// ADD BUTTON
// ============================================================================

class _EditorialAddButton extends StatefulWidget {
  const _EditorialAddButton({required this.product, required this.business});

  final Product product;
  final Business business;

  @override
  State<_EditorialAddButton> createState() => _EditorialAddButtonState();
}

class _EditorialAddButtonState extends State<_EditorialAddButton> {
  bool pressed = false;

  void _animate() {
    setState(() {
      pressed = true;
    });

    Future.delayed(const Duration(milliseconds: 120), () {
      if (!mounted) {
        return;
      }

      setState(() {
        pressed = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        _animate();
      },
      onTap: () {
        context.read<CartCubit>().addItem(
          product: widget.product,
          business: widget.business,
        );
      },
      child: AnimatedScale(
        scale: pressed ? .88 : 1,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.primary, AppColors.secondary],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: .18),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(Icons.add_rounded, color: Colors.white, size: 24),
        ),
      ),
    );
  }
}

// ============================================================================
// CART BAR
// ============================================================================

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
          child: SizedBox(
            height: 78,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 5, 14, 10),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: .25),
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(22),
                    onTap: () {
                      context.push(RoutePaths.cart);
                    },
                    splashColor: Colors.white.withValues(alpha: .08),
                    highlightColor: Colors.white.withValues(alpha: .04),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 7,
                      ),
                      child: Row(
                        children: [
                          // ===================================================
                          // ITEM COUNT
                          // ===================================================
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: .13),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '${cart.itemCount}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 10),

                          // ===================================================
                          // TITLE
                          // ===================================================
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'عرض السلة',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                SizedBox(height: 1),
                                Text(
                                  'راجع طلبك قبل إتمامه',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // ===================================================
                          // TOTAL
                          // ===================================================
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
                                fontSize: 12,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),

                          const SizedBox(width: 7),

                          // ===================================================
                          // ARROW
                          // ===================================================
                          Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: .12),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Colors.white,
                              size: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
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

// ============================================================================
// EMPTY PRODUCTS
// ============================================================================

class _EmptyProducts extends StatelessWidget {
  const _EmptyProducts();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 32),
      child: Center(
        child: AppGlassCard(
          padding: const EdgeInsets.fromLTRB(25, 28, 25, 25),
          radius: 25,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 700),
                curve: Curves.elasticOut,
                tween: Tween(begin: .75, end: 1),
                builder: (_, value, child) {
                  return Transform.scale(scale: value, child: child);
                },
                child: Container(
                  width: 84,
                  height: 84,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary.withValues(alpha: .08),
                        AppColors.secondary.withValues(alpha: .10),
                      ],
                    ),
                  ),
                  child: Icon(
                    Icons.restaurant_menu_rounded,
                    size: 38,
                    color: AppColors.primary,
                  ),
                ),
              ),

              const SizedBox(height: 18),

              const Text(
                'مفيش منتجات متاحة',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
              ),

              const SizedBox(height: 7),

              Text(
                'جرب قسم تاني وشوف الاختيارات المتاحة.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11.5,
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

// ============================================================================
// PROFILE SKELETON
// ============================================================================

class _ProfileSkeleton extends StatefulWidget {
  const _ProfileSkeleton();

  @override
  State<_ProfileSkeleton> createState() => _ProfileSkeletonState();
}

class _ProfileSkeletonState extends State<_ProfileSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final value = Curves.easeInOut.transform(_controller.value);

        final skeletonColor = Color.lerp(
          const Color(0xFFE8E8ED),
          Colors.white,
          value,
        )!;

        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ===============================================================
            // HERO
            // ===============================================================
            SliverToBoxAdapter(
              child: Container(
                height: 360,
                decoration: BoxDecoration(
                  color: skeletonColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(42),
                    bottomRight: Radius.circular(42),
                  ),
                ),
              ),
            ),

            // ===============================================================
            // INTRO
            // ===============================================================
            const SliverToBoxAdapter(child: SizedBox(height: 18)),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 60,
                            height: 9,
                            decoration: BoxDecoration(
                              color: skeletonColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          const SizedBox(height: 9),
                          Container(
                            width: 170,
                            height: 11,
                            decoration: BoxDecoration(
                              color: skeletonColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    Container(
                      width: 55,
                      height: 35,
                      decoration: BoxDecoration(
                        color: skeletonColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ===============================================================
            // CATEGORY NAV
            // ===============================================================
            const SliverToBoxAdapter(child: SizedBox(height: 14)),

            SliverToBoxAdapter(
              child: SizedBox(
                height: 91,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 28,
                        decoration: BoxDecoration(
                          color: skeletonColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      const SizedBox(width: 18),
                      Container(width: 1, height: 45, color: skeletonColor),
                      const SizedBox(width: 15),
                      Expanded(
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 4,
                          separatorBuilder: (_, __) {
                            return const SizedBox(width: 22);
                          },
                          itemBuilder: (_, index) {
                            return Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                width: index == 0 ? 52 : 76,
                                height: 13,
                                decoration: BoxDecoration(
                                  color: skeletonColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ===============================================================
            // TITLE
            // ===============================================================
            const SliverToBoxAdapter(child: SizedBox(height: 8)),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  width: 115,
                  height: 25,
                  decoration: BoxDecoration(
                    color: skeletonColor,
                    borderRadius: BorderRadius.circular(9),
                  ),
                ),
              ),
            ),

            // ===============================================================
            // PRODUCTS
            // ===============================================================
            const SliverToBoxAdapter(child: SizedBox(height: 13)),

            SliverPadding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 120),
              sliver: SliverList.separated(
                itemCount: 6,
                separatorBuilder: (_, __) {
                  return const SizedBox(height: 7);
                },
                itemBuilder: (_, __) {
                  return _SkeletonProduct(color: skeletonColor);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

// ============================================================================
// SKELETON PRODUCT
// ============================================================================

class _SkeletonProduct extends StatelessWidget {
  const _SkeletonProduct({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 128,
      child: Row(
        children: [
          Container(
            width: 108,
            height: 108,
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(32),
                topRight: Radius.circular(14),
                bottomLeft: Radius.circular(14),
                bottomRight: Radius.circular(32),
              ),
            ),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 145,
                  height: 13,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: 105,
                  height: 10,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 85,
                  height: 10,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  width: 65,
                  height: 12,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// ERROR
// ============================================================================

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: AppGlassCard(
          padding: const EdgeInsets.fromLTRB(25, 30, 25, 25),
          radius: 26,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 82,
                height: 82,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withValues(alpha: .08),
                ),
                child: Icon(
                  Icons.cloud_off_rounded,
                  color: AppColors.primary,
                  size: 38,
                ),
              ),

              const SizedBox(height: 18),

              const Text(
                'حصلت مشكلة',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
              ),

              const SizedBox(height: 8),

              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11.5,
                  height: 1.5,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 18),

              SizedBox(
                height: 44,
                child: FilledButton.icon(
                  onPressed: onRetry,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  icon: const Icon(Icons.refresh_rounded, size: 18),
                  label: const Text(
                    'حاول مرة أخرى',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800),
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
