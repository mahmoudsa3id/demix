import 'package:demix/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/business.dart';
import '../cubit/business_cubit.dart';
import '../cubit/business_state.dart';
import 'business_card.dart';

class BusinessCardList extends StatelessWidget {
  const BusinessCardList({super.key, required this.type});

  final String type;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<BusinessCubit>()..load(type),
      child: BlocBuilder<BusinessCubit, BusinessState>(
        builder: (context, state) {
          if (state is BusinessInitial || state is BusinessLoading) {
            return const SizedBox(
              height: 140,
              child: Center(child: CircularProgressIndicator()),
            );
          }

          if (state is BusinessFailure) {
            return SizedBox(
              height: 140,
              child: Center(
                child: Text(state.failure.message, textAlign: TextAlign.center),
              ),
            );
          }

          if (state is BusinessEmpty) {
            return const SizedBox(
              height: 140,
              child: Center(child: Text('No businesses available.')),
            );
          }

          final loaded = state as BusinessLoaded;

          final List<Business> businesses = loaded.businesses;

          return SizedBox(
            height: 140,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 19),
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: businesses.length,
              separatorBuilder: (_, __) => const SizedBox(width: 7),
              itemBuilder: (_, index) {
                return BusinessCard(business: businesses[index]);
              },
            ),
          );
        },
      ),
    );
  }
}
