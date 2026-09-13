import 'dart:math' as math;

import 'package:demix/core/theme/app_colors.dart';
import 'package:demix/core/theme/app_radius.dart';
import 'package:demix/core/theme/app_spacing.dart';
import 'package:demix/core/theme/app_text_styles.dart';
import 'package:demix/features/onboarding/presentation/widgets/animated_rider.dart';
import 'package:demix/features/onboarding/presentation/widgets/dots.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class OnboardingPageView extends StatelessWidget {
  final int index;
  final String image;
  final String title;
  final String description;
  final AnimationController riderController;

  const OnboardingPageView({
    super.key,
    required this.index,
    required this.image,
    required this.title,
    required this.description,
    required this.riderController,
  });

  @override
  Widget build(BuildContext context) {
    final isRider = index == 2;

    return Column(
      children: [
        const SizedBox(height: AppSpacing.xs8),

        // ========================================================
        // Image Card
        // ========================================================
        Expanded(
          flex: 7,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(36),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: .15),
                  blurRadius: 35,
                  spreadRadius: 1,
                  offset: const Offset(0, 18),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(36),
              child: Stack(
                children: [
                  // ------------------------------------------------
                  // Decorative gradients
                  // ------------------------------------------------
                  Positioned(
                    top: -75,
                    right: -60,
                    child: Container(
                      width: 210,
                      height: 210,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppColors.primary.withValues(alpha: .16),
                            AppColors.primary.withValues(alpha: 0),
                          ],
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    bottom: -80,
                    left: -60,
                    child: Container(
                      width: 220,
                      height: 220,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppColors.secondary.withValues(alpha: .16),
                            AppColors.secondary.withValues(alpha: 0),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // ------------------------------------------------
                  // Dots
                  // ------------------------------------------------
                  Positioned(
                    top: 34,
                    left: 34,
                    child: Dot(size: 9, color: AppColors.secondary),
                  ),

                  Positioned(
                    top: 65,
                    right: 45,
                    child: Dot(size: 7, color: AppColors.primary),
                  ),

                  Positioned(
                    bottom: 55,
                    left: 48,
                    child: Dot(size: 6, color: AppColors.secondary),
                  ),

                  // ------------------------------------------------
                  // Main Image
                  // ------------------------------------------------
                  Positioned.fill(
                    child: isRider
                        ? AnimatedRider(
                            image: image,
                            controller: riderController,
                          )
                        : TweenAnimationBuilder<double>(
                            tween: Tween(begin: .91, end: 1),
                            duration: const Duration(milliseconds: 800),
                            curve: Curves.easeOutBack,
                            builder: (context, value, child) {
                              return Transform.translate(
                                offset: Offset(
                                  0,
                                  math.sin(value * math.pi * 2) * 2,
                                ),
                                child: Transform.scale(
                                  scale: value,
                                  child: child,
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(AppSpacing.md),
                              child: SvgPicture.asset(
                                image,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                  ),

                  // ------------------------------------------------
                  // Bottom soft shadow
                  // ------------------------------------------------
                  Positioned(
                    left: 40,
                    right: 40,
                    bottom: 25,
                    child: Container(
                      height: 14,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppRadius.full),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: .08),
                            blurRadius: 20,
                            spreadRadius: 3,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: AppSpacing.md),

        // ========================================================
        // Text Area
        // ========================================================
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            child: Column(
              children: [
                // Gradient title
                ShaderMask(
                  shaderCallback: (bounds) {
                    return const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        AppColors.secondary,
                        Color(0xFFFF3B72),
                        AppColors.primary,
                      ],
                    ).createShader(
                      Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                    );
                  },
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.cairoExtraBold.copyWith(
                      color: Colors.white,
                      fontSize: 30,
                      height: 1.18,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.cairoMedium.copyWith(
                    color: AppColors.textTertiary,
                    fontSize: 16,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
