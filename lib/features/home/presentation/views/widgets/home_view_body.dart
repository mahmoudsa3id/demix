import 'package:demix/core/utils/helper/helper_widgets.dart';
import 'package:demix/core/widgets/bottom_nav.dart';
import 'package:demix/features/home/presentation/views/widgets/home_view_category.dart';
import 'package:demix/features/home/presentation/views/widgets/home_view_header.dart';
import 'package:demix/features/home/presentation/views/widgets/home_view_hero.dart';
import 'package:demix/features/home/presentation/views/widgets/home_view_search.dart';
import 'package:demix/features/home/presentation/views/widgets/offer_item.dart';
import 'package:demix/features/home/presentation/views/widgets/product_card_list.dart';
import 'package:demix/features/home/presentation/views/widgets/business_card_list.dart';
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

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ClipRect(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 8),
                BlocProvider(
                  create: (_) => getIt<SavedLocationCubit>()..load(),
                  child: HomeViewHeader(s: s),
                ),
                const SizedBox(height: 12),
                hero(s),
                const SizedBox(height: 10),
                search(s),
                const SizedBox(height: 10),

                const SizedBox(height: 10),
                homeViewCatogories(context, s),
                const SizedBox(height: 9),
                offerItem(s),
                const SizedBox(height: 10),
                sectionHeader(s.popularNearYou, s),
                const SizedBox(height: 5),
                BusinessCardList(),
                const SizedBox(height: 9),
                sectionHeader(s.recommendedForYou, s),
                const SizedBox(height: 5),
                productList(s),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNav(s: s),
    );
  }
}
