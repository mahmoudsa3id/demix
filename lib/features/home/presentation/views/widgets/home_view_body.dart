import 'package:demix/core/utils/helper/helper_widgets.dart';
import 'package:demix/features/business/presentation/cubit/business_cubit.dart';
import 'package:demix/features/business/presentation/cubit/business_state.dart';
import 'package:demix/features/home/presentation/views/widgets/home_business_card_list.dart';
import 'package:demix/features/home/presentation/views/widgets/home_business_empty.dart';
import 'package:demix/features/home/presentation/views/widgets/home_business_error.dart';
import 'package:demix/features/home/presentation/views/widgets/home_business_loading.dart';
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
                      return const HomeBusinessLoading();
                    }

                    if (state is BusinessFailure) {
                      return HomeBusinessError(
                        onRetry: () {
                          context.read<BusinessCubit>().loadAll();
                        },
                      );
                    }

                    if (state is BusinessLoaded) {
                      final businesses = state.businesses.take(8).toList();

                      if (businesses.isEmpty) {
                        return const HomeBusinessEmpty();
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
      ),
    );
  }
}
