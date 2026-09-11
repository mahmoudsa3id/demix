import 'package:demix/constants/constants.dart';
import 'package:demix/core/theme/app_colors.dart';
import 'package:demix/core/theme/app_radius.dart';
import 'package:demix/generated/l10n.dart';
import 'package:flutter/material.dart';

Widget homeViewCatogories(S s) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 17),
    child: Row(
      children: [
        Expanded(
          child: _category(
            title: s.restaurants,
            description: s.restaurantsDescription,
            image: Constants.burger,
            button: AppColors.secondary,
          ),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: _category(
            title: s.cafes,
            description: s.cafesDescription,
            image: Constants.coffee,
            button: AppColors.primary,
          ),
        ),
      ],
    ),
  );
}

Widget _category({
  required String title,
  required String description,
  required String image,
  required Color button,
}) {
  return SizedBox(
    height: 108,
    child: ClipRRect(
      borderRadius: AppRadius.borderRadiusMedium,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(image, fit: BoxFit.cover),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.black.withOpacity(.82),
                  Colors.transparent,
                  Colors.black.withOpacity(.62),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 7, 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 18,
                    height: 1,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 9),
                Text(
                  description,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 9.5,
                    height: 1.18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: button,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_forward_rounded,
                        color: AppColors.white,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 5),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
