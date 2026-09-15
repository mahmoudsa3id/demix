import 'package:demix/features/business/domain/entities/business.dart';
import 'package:flutter/material.dart';
import 'home_business_card.dart';

class HomeBusinessCardList extends StatelessWidget {
  const HomeBusinessCardList({super.key, required this.businesses});

  final List<Business> businesses;

  @override
  Widget build(BuildContext context) {
    if (businesses.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 158,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 17),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: businesses.length,
        separatorBuilder: (_, __) {
          return const SizedBox(width: 10);
        },
        itemBuilder: (context, index) {
          return HomeBusinessCard(business: businesses[index]);
        },
      ),
    );
  }
}
