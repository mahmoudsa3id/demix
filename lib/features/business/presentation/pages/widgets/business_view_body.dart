import 'package:demix/core/theme/app_colors.dart';
import 'package:demix/core/widgets/app_background_page.dart';
import 'package:demix/features/business/domain/entities/business.dart';
import 'package:demix/features/business/presentation/cubit/business_cubit.dart';
import 'package:demix/features/business/presentation/cubit/business_state.dart';
import 'package:demix/features/business/presentation/pages/widgets/business_category_icon.dart';
import 'package:demix/features/business/presentation/pages/widgets/business_top_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class BusinessViewBody extends StatefulWidget {
  const BusinessViewBody({super.key, required this.type, required this.isCafe});

  final String type;
  final bool isCafe;

  @override
  State<BusinessViewBody> createState() => _BusinessViewBodyState();
}

class _BusinessViewBodyState extends State<BusinessViewBody> {
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
                      BusinessTopButton(
                        icon: Icons.arrow_back_ios_new_rounded,
                        onTap: () => context.pop(),
                      ),
                      const Spacer(),
                      BusinessCategoryIcon(icon: icon),
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
