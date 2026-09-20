import 'package:demix/core/routing/navigation.dart';
import 'package:demix/core/widgets/app_background_page.dart';
import 'package:demix/features/business/presentation/cubit/business_profile_cubit.dart';
import 'package:demix/features/business/presentation/cubit/business_profile_state.dart';
import 'package:demix/features/orders/presentation/pages/widgets/orders_error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BusinessProfileViewBody extends StatefulWidget {
  const BusinessProfileViewBody({super.key, required this.businessId});

  final String businessId;

  @override
  State<BusinessProfileViewBody> createState() =>
      _BusinessProfileViewBodyState();
}

class _BusinessProfileViewBodyState extends State<BusinessProfileViewBody> {
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
              return ErrorState(
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
