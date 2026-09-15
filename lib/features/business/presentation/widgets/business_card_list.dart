import 'package:demix/features/business/domain/entities/business.dart';
import 'package:flutter/material.dart';
import 'business_card.dart';

class BusinessCardList extends StatelessWidget {
  const BusinessCardList({super.key, required this.businesses});

  final List<Business> businesses;

  @override
  Widget build(BuildContext context) {
    if (businesses.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(17, 8, 17, 24),
      sliver: SliverList.separated(
        itemCount: businesses.length,
        separatorBuilder: (_, __) {
          return const SizedBox(height: 10);
        },
        itemBuilder: (context, index) {
          return BusinessCard(business: businesses[index]);
        },
      ),
    );
  }
}
