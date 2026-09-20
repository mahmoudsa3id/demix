import 'package:demix/core/di/injection.dart';
import 'package:demix/core/theme/app_colors.dart';
import 'package:demix/core/widgets/app_background_page.dart';
import 'package:demix/features/business/domain/entities/business.dart';
import 'package:demix/features/business/presentation/cubit/business_cubit.dart';
import 'package:demix/features/business/presentation/cubit/business_state.dart';
import 'package:demix/features/business/presentation/widgets/business_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CategoryView extends StatelessWidget {
  const CategoryView({super.key, required this.type});

  final String type;

  bool get isCafe => type.toLowerCase() == 'cafe';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<BusinessCubit>()..load(type),
      child: _CategoryBody(type: type, isCafe: isCafe),
    );
  }
}

class _CategoryBody extends StatefulWidget {
  const _CategoryBody({required this.type, required this.isCafe});

  final String type;
  final bool isCafe;

  @override
  State<_CategoryBody> createState() => _CategoryBodyState();
}

class _CategoryBodyState extends State<_CategoryBody> {
  late final TextEditingController _searchController;
  late final FocusNode _searchFocusNode;

  String _query = '';

  @override
  void initState() {
    super.initState();

    _searchController = TextEditingController();
    _searchFocusNode = FocusNode();

    _searchController.addListener(() {
      final value = _searchController.text.trim();

      if (value == _query) return;

      setState(() {
        _query = value;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  List<Business> _filterBusinesses(List<Business> businesses) {
    final query = _query.trim().toLowerCase();

    if (query.isEmpty) {
      return businesses;
    }

    return businesses.where((business) {
      final values = <String>[
        business.name,
        business.nameAr ?? '',
        business.nameEn ?? '',
        business.address ?? '',
      ];

      return values.any((value) => value.toLowerCase().contains(query));
    }).toList();
  }

  void _clearSearch() {
    _searchController.clear();
    _searchFocusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.isCafe ? 'الكافيهات' : 'المطاعم';

    final subtitle = widget.isCafe
        ? 'اكتشف كافيهك المفضل واطلب في دقائق'
        : 'اكتشف أفضل المطاعم حولك واطلب بسهولة';

    final icon = widget.isCafe
        ? Icons.local_cafe_rounded
        : Icons.restaurant_rounded;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FA),
      body: AppPageBackground(
        child: SafeArea(
          bottom: false,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ============================================================
              // TOP BAR
              // ============================================================
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 14, 18, 0),
                  child: Row(
                    children: [
                      _TopButton(
                        icon: Icons.arrow_back_ios_new_rounded,
                        onTap: () => context.pop(),
                      ),
                      const Spacer(),
                      _CategoryIcon(icon: icon),
                    ],
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 12)),

              // ============================================================
              // HERO TITLE
              // ============================================================
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 32,
                          height: 1,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -1.2,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                          height: 1.45,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 22)),

              // ============================================================
              // SEARCH
              // ============================================================
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _SearchBar(
                    controller: _searchController,
                    focusNode: _searchFocusNode,
                    isCafe: widget.isCafe,
                    hasQuery: _query.isNotEmpty,
                    onClear: _clearSearch,
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 18)),

              // ============================================================
              // SECTION TITLE
              // ============================================================
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 19),
                  child: BlocBuilder<BusinessCubit, BusinessState>(
                    builder: (context, state) {
                      if (state is! BusinessLoaded) {
                        return const SizedBox.shrink();
                      }

                      final businesses = _filterBusinesses(state.businesses);

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _query.isEmpty
                                      ? 'اختياراتنا ليك'
                                      : 'نتائج البحث',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _query.isEmpty
                                      ? 'أماكن تقدر تطلب منها دلوقتي'
                                      : 'الأماكن المطابقة لبحثك',
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 7,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.white),
                            ),
                            child: Text(
                              '${businesses.length}',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 11,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 11)),

              // ============================================================
              // CONTENT
              // ============================================================
              BlocBuilder<BusinessCubit, BusinessState>(
                builder: (context, state) {
                  // --------------------------------------------------------
                  // LOADING
                  // --------------------------------------------------------

                  if (state is BusinessInitial || state is BusinessLoading) {
                    return const SliverPadding(
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 35),
                      sliver: SliverToBoxAdapter(child: _LoadingContent()),
                    );
                  }

                  // --------------------------------------------------------
                  // ERROR
                  // --------------------------------------------------------

                  if (state is BusinessFailure) {
                    return SliverFillRemaining(
                      hasScrollBody: false,
                      child: _EmptyState(
                        icon: Icons.wifi_off_rounded,
                        title: 'حصلت مشكلة',
                        message: state.message,
                        buttonText: 'إعادة المحاولة',
                        onPressed: () {
                          context.read<BusinessCubit>().load(widget.type);
                        },
                      ),
                    );
                  }

                  // --------------------------------------------------------
                  // LOADED
                  // --------------------------------------------------------

                  if (state is BusinessLoaded) {
                    final businesses = _filterBusinesses(state.businesses);

                    if (businesses.isEmpty) {
                      return SliverFillRemaining(
                        hasScrollBody: false,
                        child: _SearchEmptyState(
                          isSearch: _query.trim().isNotEmpty,
                          isCafe: widget.isCafe,
                          query: _query,
                          onClear: _query.isNotEmpty ? _clearSearch : null,
                        ),
                      );
                    }

                    return SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 35),
                      sliver: SliverList.separated(
                        itemCount: businesses.length,
                        separatorBuilder: (_, __) {
                          return const SizedBox(height: 16);
                        },
                        itemBuilder: (context, index) {
                          return _BusinessAnimatedItem(
                            index: index,
                            child: BusinessCard(business: businesses[index]),
                          );
                        },
                      ),
                    );
                  }

                  return const SliverToBoxAdapter(child: SizedBox.shrink());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// TOP BUTTON
// ============================================================================

class _TopButton extends StatelessWidget {
  const _TopButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: .90),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: const SizedBox(
          width: 45,
          height: 45,
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 17,
            color: AppColors.black,
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// CATEGORY ICON
// ============================================================================

class _CategoryIcon extends StatelessWidget {
  const _CategoryIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withValues(alpha: .13),
            AppColors.secondary.withValues(alpha: .13),
          ],
        ),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: Colors.white, width: 1.2),
      ),
      child: Icon(icon, color: AppColors.primary, size: 23),
    );
  }
}

// ============================================================================
// SEARCH BAR
// ============================================================================

class _SearchBar extends StatelessWidget {
  const _SearchBar({
    required this.controller,
    required this.focusNode,
    required this.isCafe,
    required this.hasQuery,
    required this.onClear,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isCafe;
  final bool hasQuery;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: focusNode.hasFocus
              ? AppColors.primary.withValues(alpha: .20)
              : Colors.white,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: .035),
            blurRadius: 28,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 7),

          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withValues(alpha: .09),
                  AppColors.secondary.withValues(alpha: .09),
                ],
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              Icons.search_rounded,
              color: AppColors.primary,
              size: 22,
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              textInputAction: TextInputAction.search,
              textDirection: TextDirection.rtl,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                isCollapsed: true,
                hintText: 'ابحث عن ${isCafe ? 'كافيه' : 'مطعم'}...',
                hintStyle: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            child: hasQuery
                ? IconButton(
                    key: const ValueKey('clear'),
                    onPressed: onClear,
                    icon: Icon(
                      Icons.close_rounded,
                      color: AppColors.textSecondary,
                      size: 20,
                    ),
                  )
                : Container(
                    key: const ValueKey('filter'),
                    margin: const EdgeInsets.only(right: 8),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF6F6F8),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Icon(
                      Icons.tune_rounded,
                      color: AppColors.textSecondary,
                      size: 19,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// BUSINESS ANIMATION
// ============================================================================

class _BusinessAnimatedItem extends StatelessWidget {
  const _BusinessAnimatedItem({required this.index, required this.child});

  final int index;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 350 + (index * 65)),
      curve: Curves.easeOutCubic,
      tween: Tween(begin: 0, end: 1),
      builder: (context, value, child) {
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

// ============================================================================
// LOADING
// ============================================================================

class _LoadingContent extends StatefulWidget {
  const _LoadingContent();

  @override
  State<_LoadingContent> createState() => _LoadingContentState();
}

class _LoadingContentState extends State<_LoadingContent>
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
        final progress = Curves.easeInOut.transform(_controller.value);

        final baseColor = Color.lerp(
          const Color(0xFFEDEDF1),
          Colors.white,
          progress,
        )!;

        return Column(
          children: List.generate(3, (index) {
            return Container(
              height: 220,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: baseColor,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white),
              ),
            );
          }),
        );
      },
    );
  }
}

// ============================================================================
// SEARCH EMPTY
// ============================================================================

class _SearchEmptyState extends StatelessWidget {
  const _SearchEmptyState({
    required this.isSearch,
    required this.isCafe,
    required this.query,
    required this.onClear,
  });

  final bool isSearch;
  final bool isCafe;
  final String query;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    final icon = isSearch
        ? Icons.search_off_rounded
        : (isCafe ? Icons.local_cafe_rounded : Icons.restaurant_rounded);

    final title = isSearch ? 'مفيش نتائج' : 'مفيش أماكن متاحة';

    final message = isSearch
        ? 'مش لقينا مكان مطابق لـ "$query"'
        : 'مفيش أماكن متاحة حاليًا.';

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: AppGlassCard(
          padding: const EdgeInsets.fromLTRB(26, 30, 26, 26),
          radius: 26,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 82,
                height: 82,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: .09),
                      AppColors.secondary.withValues(alpha: .10),
                    ],
                  ),
                ),
                child: Icon(icon, color: AppColors.primary, size: 35),
              ),
              const SizedBox(height: 18),
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
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11.5,
                  height: 1.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (onClear != null) ...[
                const SizedBox(height: 17),
                SizedBox(
                  height: 43,
                  child: FilledButton(
                    onPressed: onClear,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'مسح البحث',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// ERROR / EMPTY
// ============================================================================

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.icon,
    required this.title,
    required this.message,
    this.buttonText,
    this.onPressed,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? buttonText;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: AppGlassCard(
          padding: const EdgeInsets.fromLTRB(24, 30, 24, 24),
          radius: 25,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 78,
                height: 78,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withValues(alpha: .08),
                ),
                child: Icon(icon, size: 34, color: AppColors.primary),
              ),
              const SizedBox(height: 17),
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
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11.5,
                  height: 1.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (onPressed != null) ...[
                const SizedBox(height: 17),
                SizedBox(
                  height: 43,
                  child: FilledButton(
                    onPressed: onPressed,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      buttonText ?? 'حاول مرة أخرى',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
