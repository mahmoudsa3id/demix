import 'package:demix/features/business/domain/entities/business.dart';
import 'package:demix/features/business/presentation/pages/widgets/hero_circle_button.dart';
import 'package:demix/features/business/presentation/pages/widgets/hero_favorite_button.dart';
import 'package:demix/features/favorite/domain/entities/favourite_entity.dart';
import 'package:demix/features/favorite/presentation/cubit/favorites_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class BusinessProfileHeroActions extends StatelessWidget {
  const BusinessProfileHeroActions({super.key, required this.business});

  final Business business;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Row(
      children: [
        // =====================================================================
        // BACK
        // =====================================================================
        HeroCircleButton(
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

              return HeroFavoriteButton(
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
