import 'package:demix/core/utils/helper/helper_widgets.dart';
import 'package:demix/core/widgets/bottom_nav.dart';
import 'package:demix/features/business/presentation/cubit/business_cubit.dart';
import 'package:demix/features/business/presentation/cubit/business_state.dart';
import 'package:demix/features/business/presentation/cubit/test.dart';
import 'package:demix/features/home/presentation/views/widgets/home_business_card_list.dart';
import 'package:demix/features/home/presentation/views/widgets/home_view_category.dart';
import 'package:demix/features/home/presentation/views/widgets/home_view_header.dart';
import 'package:demix/features/home/presentation/views/widgets/home_view_hero.dart';
import 'package:demix/features/home/presentation/views/widgets/home_view_search.dart';
import 'package:demix/features/home/presentation/views/widgets/offer_item.dart';
import 'package:demix/features/home/presentation/views/widgets/product_card_list.dart';
import 'package:demix/features/location/presentation/cubit/saved_location_cubit.dart';
import 'package:demix/generated/l10n.dart';
import 'package:demix/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider<SavedLocationCubit>(
          create: (_) => getIt<SavedLocationCubit>()..load(),
        ),
        BlocProvider<BusinessCubit>(
          create: (_) => getIt<BusinessCubit>()..loadAll(),
        ),
      ],
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 8),

                HomeViewHeader(s: s),

                const SizedBox(height: 12),

                hero(s),

                const SizedBox(height: 10),

                search(s),

                const SizedBox(height: 12),

                homeViewCatogories(context, s),

                const SizedBox(height: 10),

                offerItem(s),

                const SizedBox(height: 14),

                sectionHeader(s.popularNearYou, s),

                const SizedBox(height: 7),

                BlocBuilder<BusinessCubit, BusinessState>(
                  builder: (context, state) {
                    if (state is BusinessLoading || state is BusinessInitial) {
                      return const _HomeBusinessLoading();
                    }

                    if (state is BusinessFailure) {
                      return _HomeBusinessError(
                        onRetry: () {
                          context.read<BusinessCubit>().loadAll();
                        },
                      );
                    }

                    if (state is BusinessLoaded) {
                      final businesses = state.businesses.take(8).toList();

                      if (businesses.isEmpty) {
                        return const _HomeBusinessEmpty();
                      }

                      return HomeBusinessCardList(businesses: businesses);
                    }

                    return const SizedBox.shrink();
                  },
                ),

                const SizedBox(height: 16),

                sectionHeader(s.recommendedForYou, s),

                const SizedBox(height: 7),

                productList(s),
              ],
            ),
          ),
        ),

        bottomNavigationBar: BottomNav(s: s),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            try {
              await getIt<BusinessMockSeeder>().seedRestaurant();

              if (!context.mounted) return;

              await context.read<BusinessCubit>().loadAll();

              if (!context.mounted) return;

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Restaurant added successfully')),
              );
            } catch (e) {
              if (!context.mounted) return;

              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Error: $e')));
            }
          },
          child: const Icon(Icons.add_business_rounded),
        ),
      ),
    );
  }
}

class _HomeBusinessLoading extends StatelessWidget {
  const _HomeBusinessLoading();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SizedBox(
      height: 158,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 17),
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 3,
        separatorBuilder: (_, __) {
          return const SizedBox(width: 10);
        },
        itemBuilder: (_, __) {
          return Container(
            width: 145,
            decoration: BoxDecoration(
              color: colors.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(16),
            ),
          );
        },
      ),
    );
  }
}

class _HomeBusinessEmpty extends StatelessWidget {
  const _HomeBusinessEmpty();

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 17),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 18),
        decoration: BoxDecoration(
          color: colors.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(
              Icons.restaurant_outlined,
              size: 34,
              color: colors.onSurfaceVariant,
            ),
            const SizedBox(height: 8),
            Text(
              s.noRestaurantsAvailable,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colors.onSurfaceVariant,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeBusinessError extends StatelessWidget {
  const _HomeBusinessError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 17),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: colors.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(
              Icons.cloud_off_rounded,
              size: 22,
              color: colors.onSurfaceVariant,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                s.failedToLoadRestaurants,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            TextButton(onPressed: onRetry, child: Text(s.retry)),
          ],
        ),
      ),
    );
  }
}
