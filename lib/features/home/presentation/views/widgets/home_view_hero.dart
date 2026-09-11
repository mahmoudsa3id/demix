import 'package:demix/core/theme/app_colors.dart';
import 'package:demix/features/home/presentation/views/widgets/tasty_moment_in_hero.dart';
import 'package:demix/generated/l10n.dart';
import 'package:flutter/material.dart';

Widget hero(S s) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                s.heroTitle,
                style: const TextStyle(
                  fontSize: 36,
                  height: .93,
                  letterSpacing: -1.8,
                  fontWeight: FontWeight.w900,
                  color: AppColors.black,
                ),
              ),
              ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (r) => const LinearGradient(
                  colors: [
                    AppColors.secondary,
                    Color(0xFFFF3D4D),
                    AppColors.primary,
                  ],
                ).createShader(r),
                child: Text(
                  s.heroSubtitle,
                  style: const TextStyle(
                    fontSize: 36,
                    height: .93,
                    letterSpacing: -1.8,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                s.heroDescription,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF34343B),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 7),
        const TastyMomentsInHero(),
      ],
    ),
  );
}
