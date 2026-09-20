import 'package:demix/core/di/injection.dart';
import 'package:demix/core/theme/app_colors.dart';
import 'package:demix/core/widgets/app_background_page.dart';
import 'package:demix/core/widgets/app_cached_image.dart';
import 'package:demix/features/favorite/domain/entities/favourite_entity.dart';
import 'package:demix/features/favorite/presentation/cubit/favorites_cubit.dart';
import 'package:demix/generated/l10n.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritesView extends StatelessWidget {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const _GuestFavoritesView();
    }

    return BlocProvider(
      create: (_) => getIt<FavoritesCubit>(param1: user.uid)..load(),
      child: const _FavoritesBody(),
    );
  }
}

class _FavoritesBody extends StatelessWidget {
  const _FavoritesBody();

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F8FB),
        body: AppPageBackground(
          child: SafeArea(
            bottom: false,
            child: Column(
              children: [
                // ============================================================
                // HEADER
                // ============================================================
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              s.favorites,
                              style: const TextStyle(
                                fontSize: 27,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.8,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'كل حاجاتك المفضلة في مكان واحد',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),

                      BlocBuilder<FavoritesCubit, FavoritesState>(
                        builder: (context, state) {
                          if (state is! FavoritesLoaded) {
                            return const SizedBox.shrink();
                          }

                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 11,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.92),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: Colors.white),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.03),
                                  blurRadius: 16,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.favorite_rounded,
                                  color: AppColors.secondary,
                                  size: 15,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  '${state.favorites.length}',
                                  style: const TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                // ============================================================
                // TABS
                // ============================================================
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: AppGlassCard(
                    padding: const EdgeInsets.all(5),
                    radius: 18,
                    child: TabBar(
                      dividerColor: Colors.transparent,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicator: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [AppColors.primary, AppColors.secondary],
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      labelColor: Colors.white,
                      unselectedLabelColor: AppColors.textSecondary,
                      labelStyle: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w900,
                      ),
                      unselectedLabelStyle: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                      ),
                      tabs: const [
                        Tab(
                          icon: Icon(Icons.restaurant_rounded, size: 16),
                          text: 'المطاعم',
                          iconMargin: EdgeInsets.only(bottom: 2),
                        ),
                        Tab(
                          icon: Icon(Icons.local_cafe_rounded, size: 16),
                          text: 'الكافيهات',
                          iconMargin: EdgeInsets.only(bottom: 2),
                        ),
                        Tab(
                          icon: Icon(Icons.fastfood_rounded, size: 16),
                          text: 'المنتجات',
                          iconMargin: EdgeInsets.only(bottom: 2),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // ============================================================
                // CONTENT
                // ============================================================
                Expanded(
                  child: BlocBuilder<FavoritesCubit, FavoritesState>(
                    builder: (context, state) {
                      if (state is FavoritesInitial ||
                          state is FavoritesLoading) {
                        return const _FavoritesLoading();
                      }

                      if (state is FavoritesFailure) {
                        return _FavoritesError(
                          message: state.message,
                          onRetry: () {
                            context.read<FavoritesCubit>().load();
                          },
                        );
                      }

                      if (state is FavoritesLoaded) {
                        return TabBarView(
                          physics: const BouncingScrollPhysics(),
                          children: [
                            _BusinessFavoritesList(
                              favorites: state.restaurants,
                            ),
                            _BusinessFavoritesList(favorites: state.cafes),
                            _ProductFavoritesList(favorites: state.products),
                          ],
                        );
                      }

                      return const SizedBox.shrink();
                    },
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

// =============================================================================
// BUSINESS LIST
// =============================================================================

class _BusinessFavoritesList extends StatelessWidget {
  const _BusinessFavoritesList({required this.favorites});

  final List<FavoriteEntity> favorites;

  @override
  Widget build(BuildContext context) {
    if (favorites.isEmpty) {
      return const _EmptyState(
        icon: Icons.favorite_border_rounded,
        title: 'مفيش أماكن مفضلة',
        subtitle: 'ضيف المطاعم والكافيهات اللي بتحبها للمفضلة وهتلاقيها هنا.',
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 2, 16, 30),
      physics: const BouncingScrollPhysics(),
      itemCount: favorites.length,
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        final favorite = favorites[index];

        return _FavoriteAnimatedEntry(
          index: index,
          child: _BusinessFavoriteCard(
            favorite: favorite,
            onFavoriteTap: () {
              context.read<FavoritesCubit>().remove(favorite.id);
            },
          ),
        );
      },
    );
  }
}

// =============================================================================
// BUSINESS CARD
// =============================================================================

class _BusinessFavoriteCard extends StatelessWidget {
  const _BusinessFavoriteCard({
    required this.favorite,
    required this.onFavoriteTap,
  });

  final FavoriteEntity favorite;
  final VoidCallback onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    final coverUrl = favorite.coverUrl?.trim() ?? '';
    final logoUrl = favorite.logoUrl?.trim() ?? '';

    final isCafe = favorite.type == FavoriteType.cafe;

    return AppGlassCard(
      padding: EdgeInsets.zero,
      radius: 24,
      child: Column(
        children: [
          SizedBox(
            height: 158,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Cover
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                    child: coverUrl.isNotEmpty
                        ? AppCachedImage(imageUrl: coverUrl, fit: BoxFit.cover)
                        : Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  AppColors.primary,
                                  AppColors.secondary,
                                ],
                              ),
                            ),
                            child: Icon(
                              isCafe
                                  ? Icons.local_cafe_rounded
                                  : Icons.restaurant_rounded,
                              color: Colors.white,
                              size: 42,
                            ),
                          ),
                  ),
                ),

                // Cover Overlay
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.35),
                        ],
                      ),
                    ),
                  ),
                ),

                // Favorite
                Positioned(
                  top: 12,
                  right: 12,
                  child: _FavoriteButton(onTap: onFavoriteTap),
                ),

                // Logo
                Positioned(
                  left: 16,
                  bottom: -30,
                  child: Container(
                    width: 68,
                    height: 68,
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.10),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: logoUrl.isNotEmpty
                          ? AppCachedImage(imageUrl: logoUrl, fit: BoxFit.cover)
                          : Container(
                              color: AppColors.primary.withValues(alpha: 0.07),
                              child: Icon(
                                isCafe
                                    ? Icons.local_cafe_rounded
                                    : Icons.restaurant_rounded,
                                color: AppColors.primary,
                                size: 28,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Info
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 37, 16, 16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        favorite.displayName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            color: Color(0xFFFFB800),
                            size: 17,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            (favorite.rating ?? 0).toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          if ((favorite.reviewCount ?? 0) > 0) ...[
                            const SizedBox(width: 5),
                            Text(
                              '(${favorite.reviewCount})',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 10.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                _BusinessTypeBadge(text: isCafe ? 'كافيه' : 'مطعم'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// PRODUCT LIST
// =============================================================================

class _ProductFavoritesList extends StatelessWidget {
  const _ProductFavoritesList({required this.favorites});

  final List<FavoriteEntity> favorites;

  @override
  Widget build(BuildContext context) {
    if (favorites.isEmpty) {
      return const _EmptyState(
        icon: Icons.fastfood_outlined,
        title: 'مفيش منتجات مفضلة',
        subtitle: 'ضيف المنتجات اللي بتحبها للمفضلة وهتلاقيها هنا.',
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 2, 16, 30),
      physics: const BouncingScrollPhysics(),
      itemCount: favorites.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final favorite = favorites[index];

        return _FavoriteAnimatedEntry(
          index: index,
          child: _ProductFavoriteCard(
            favorite: favorite,
            onFavoriteTap: () {
              context.read<FavoritesCubit>().remove(favorite.id);
            },
          ),
        );
      },
    );
  }
}

// =============================================================================
// PRODUCT CARD
// =============================================================================

class _ProductFavoriteCard extends StatelessWidget {
  const _ProductFavoriteCard({
    required this.favorite,
    required this.onFavoriteTap,
  });

  final FavoriteEntity favorite;
  final VoidCallback onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    final productImage = favorite.imageUrl?.trim() ?? '';
    final businessLogo = favorite.businessLogo?.trim() ?? '';

    return AppGlassCard(
      padding: const EdgeInsets.all(10),
      radius: 22,
      child: Row(
        children: [
          // Product Image
          Container(
            width: 104,
            height: 104,
            decoration: BoxDecoration(
              color: const Color(0xFFF2F2F5),
              borderRadius: BorderRadius.circular(18),
            ),
            clipBehavior: Clip.antiAlias,
            child: productImage.isNotEmpty
                ? AppCachedImage(imageUrl: productImage, fit: BoxFit.cover)
                : Icon(
                    Icons.fastfood_rounded,
                    color: AppColors.textSecondary,
                    size: 32,
                  ),
          ),

          const SizedBox(width: 13),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        favorite.displayName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          height: 1.25,
                        ),
                      ),
                    ),
                    const SizedBox(width: 7),
                    _FavoriteButton(onTap: onFavoriteTap, compact: true),
                  ],
                ),

                const SizedBox(height: 9),

                // Business
                if ((favorite.businessName ?? '').trim().isNotEmpty)
                  Row(
                    children: [
                      Container(
                        width: 27,
                        height: 27,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF2F2F5),
                          shape: BoxShape.circle,
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: businessLogo.isNotEmpty
                            ? AppCachedImage(
                                imageUrl: businessLogo,
                                fit: BoxFit.cover,
                              )
                            : Icon(
                                Icons.storefront_rounded,
                                color: AppColors.textSecondary,
                                size: 14,
                              ),
                      ),
                      const SizedBox(width: 7),
                      Expanded(
                        child: Text(
                          favorite.businessName!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),

                const SizedBox(height: 10),

                // Price + Rating
                Row(
                  children: [
                    if (favorite.price != null)
                      Text(
                        '${favorite.price!.toStringAsFixed(0)} ج',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    const Spacer(),
                    if (favorite.businessRating != null)
                      Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            size: 16,
                            color: Color(0xFFFFB800),
                          ),
                          const SizedBox(width: 3),
                          Text(
                            favorite.businessRating!.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// FAVORITE BUTTON
// =============================================================================

class _FavoriteButton extends StatelessWidget {
  const _FavoriteButton({required this.onTap, this.compact = false});

  final VoidCallback onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final size = compact ? 34.0 : 42.0;
    final iconSize = compact ? 17.0 : 21.0;

    return Material(
      color: Colors.white.withValues(alpha: 0.94),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: size,
          height: size,
          child: Icon(
            Icons.favorite_rounded,
            size: iconSize,
            color: AppColors.secondary,
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// BUSINESS TYPE
// =============================================================================

class _BusinessTypeBadge extends StatelessWidget {
  const _BusinessTypeBadge({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(11),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: AppColors.primary,
          fontSize: 9.5,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

// =============================================================================
// EMPTY
// =============================================================================

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: AppGlassCard(
          padding: const EdgeInsets.fromLTRB(26, 30, 26, 27),
          radius: 25,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 700),
                curve: Curves.elasticOut,
                tween: Tween(begin: 0.80, end: 1.0),
                builder: (_, value, child) {
                  return Transform.scale(scale: value, child: child);
                },
                child: Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary.withValues(alpha: 0.09),
                        AppColors.secondary.withValues(alpha: 0.10),
                      ],
                    ),
                  ),
                  child: Icon(icon, size: 40, color: AppColors.secondary),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
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

// =============================================================================
// LOADING
// =============================================================================

class _FavoritesLoading extends StatelessWidget {
  const _FavoritesLoading();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 2, 16, 30),
      physics: const BouncingScrollPhysics(),
      itemCount: 5,
      separatorBuilder: (_, __) => const SizedBox(height: 13),
      itemBuilder: (_, index) {
        return const _FavoriteSkeleton();
      },
    );
  }
}

class _FavoriteSkeleton extends StatefulWidget {
  const _FavoriteSkeleton();

  @override
  State<_FavoriteSkeleton> createState() => _FavoriteSkeletonState();
}

class _FavoriteSkeletonState extends State<_FavoriteSkeleton>
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
      builder: (_, __) {
        final value = Curves.easeInOut.transform(_controller.value);

        final skeletonColor = Color.lerp(
          const Color(0xFFEDEDF0),
          Colors.white,
          value,
        )!;

        return AppGlassCard(
          padding: const EdgeInsets.all(10),
          radius: 22,
          child: Row(
            children: [
              Container(
                width: 104,
                height: 104,
                decoration: BoxDecoration(
                  color: skeletonColor,
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 145,
                      height: 13,
                      decoration: BoxDecoration(
                        color: skeletonColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: 105,
                      height: 10,
                      decoration: BoxDecoration(
                        color: skeletonColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      width: 72,
                      height: 12,
                      decoration: BoxDecoration(
                        color: skeletonColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// =============================================================================
// ERROR
// =============================================================================

class _FavoritesError extends StatelessWidget {
  const _FavoritesError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: AppGlassCard(
          padding: const EdgeInsets.all(25),
          radius: 24,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.error_outline_rounded,
                  color: AppColors.secondary,
                  size: 34,
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                'حصل خطأ',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11.5,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 17),
              SizedBox(
                height: 45,
                child: FilledButton(
                  onPressed: onRetry,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'إعادة المحاولة',
                    style: TextStyle(fontWeight: FontWeight.w800),
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

// =============================================================================
// GUEST
// =============================================================================

class _GuestFavoritesView extends StatelessWidget {
  const _GuestFavoritesView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FB),
      body: AppPageBackground(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: AppGlassCard(
              padding: const EdgeInsets.all(26),
              radius: 24,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 82,
                    height: 82,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.secondary.withValues(alpha: 0.08),
                    ),
                    child: const Icon(
                      Icons.favorite_border_rounded,
                      size: 40,
                      color: AppColors.secondary,
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'سجل الدخول أولًا',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    'سجل الدخول عشان تحفظ وتعرض المفضلة على جهازك.',
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
        ),
      ),
    );
  }
}

// =============================================================================
// ENTRY ANIMATION
// =============================================================================

class _FavoriteAnimatedEntry extends StatelessWidget {
  const _FavoriteAnimatedEntry({required this.index, required this.child});

  final int index;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 320 + (index * 65)),
      curve: Curves.easeOutCubic,
      tween: Tween(begin: 0, end: 1),
      builder: (_, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 18 * (1 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
