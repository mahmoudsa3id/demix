import 'package:demix/constants/constants.dart';
import 'package:demix/features/home/presentation/views/widgets/product_card.dart';
import 'package:demix/generated/l10n.dart';
import 'package:flutter/material.dart';

Widget productList(S s) {
  final items = [
    ('Iced Latte', '75', Constants.coffee),
    ('Chicken Wrap', '95', Constants.coffee),
    ('Classic Burger Meal', '120', Constants.coffee),
    ('Chocolate Cake', '80', Constants.coffee),
  ];

  return SizedBox(
    height: 160,
    child: ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 19),
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(width: 7),
      itemBuilder: (_, i) {
        final x = items[i];
        return ProductCard(
          index: i,
          name: x.$1,
          price: x.$2,
          image: x.$3,
          s: s,
        );
      },
    ),
  );
}
