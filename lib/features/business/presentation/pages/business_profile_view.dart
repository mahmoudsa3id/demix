import 'package:demix/core/di/injection.dart';

import 'package:demix/features/business/presentation/cubit/business_profile_cubit.dart';
import 'package:demix/features/business/presentation/pages/widgets/business_profile_view_body.dart';

import 'package:demix/features/favorite/presentation/cubit/favorites_cubit.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BusinessProfileView extends StatelessWidget {
  const BusinessProfileView({super.key, required this.businessId});

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
      child: BusinessProfileViewBody(businessId: businessId),
    );
  }
}

// ============================================================================
// BUSINESS PROFILE VIEW
// ============================================================================



// ============================================================================
// HERO
// ============================================================================



// ============================================================================
// HERO ACTIONS
// ============================================================================



// ============================================================================
// LIVE OPEN STATUS
// ============================================================================


// ============================================================================
// OPEN STATUS PILL
// ============================================================================



// ============================================================================
// HERO CIRCLE BUTTON
// ============================================================================

