import 'package:demix/core/theme/app_colors.dart';
import 'package:demix/generated/l10n.dart';
import 'package:flutter/material.dart';

Widget circleIcon(IconData icon) {
  return Container(
    width: 40,
    height: 40,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: AppColors.white,
      border: Border.all(color: AppColors.border),
    ),
    child: Icon(icon, size: 24, color: AppColors.black),
  );
}

Widget badge(String value) {
  return Container(
    width: 17,
    height: 17,
    alignment: Alignment.center,
    decoration: const BoxDecoration(
      color: AppColors.secondary,
      shape: BoxShape.circle,
    ),
    child: Text(
      value,
      style: const TextStyle(
        color: AppColors.white,
        fontSize: 8,
        fontWeight: FontWeight.w900,
      ),
    ),
  );
}

Widget sectionHeader(String title, S s) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 19),
    child: Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.black,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        Text(
          s.seeAll,
          style: const TextStyle(
            color: AppColors.primary,
            fontSize: 9,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(width: 4),
        const Icon(
          Icons.arrow_forward_rounded,
          color: AppColors.primary,
          size: 16,
        ),
      ],
    ),
  );
}
