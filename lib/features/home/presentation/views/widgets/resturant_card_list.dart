import 'package:demix/constants/constants.dart';
import 'package:demix/features/home/presentation/views/widgets/resturant_card.dart';
import 'package:flutter/material.dart';

class BusinessCardList extends StatelessWidget {
  const BusinessCardList({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      (
        'McDonald\'s',
        Constants.coffee,
        '20–30 min',
        '4.8 (12k+)',
        'Fast Food • Burgers • \$\$',
      ),
      (
        'Starbucks',
        Constants.coffee,
        '15–25 min',
        '4.7 (9k+)',
        'Café • Drinks • \$\$',
      ),
      (
        'KFC',
        Constants.coffee,
        '25–35 min',
        '4.6 (8k+)',
        'Chicken • Fast Food • \$\$',
      ),
      (
        'Pizza Hut',
        Constants.coffee,
        '20–30 min',
        '4.5 (6k+)',
        'Pizza • Italian • \$\$',
      ),
    ];

    return SizedBox(
      height: 140,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 19),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 7),
        itemBuilder: (_, i) {
          final x = items[i];
          return BusinessCard(
            name: x.$1,
            image: x.$2,
            time: x.$3,
            rating: x.$4,
            type: x.$5,
          );
        },
      ),
    );
  }
}
