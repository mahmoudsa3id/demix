import 'package:demix/core/theme/app_colors.dart';
import 'package:demix/core/widgets/app_background_page.dart';
import 'package:flutter/material.dart';

class BusinessProfileEmptyProduct extends StatelessWidget {
  const BusinessProfileEmptyProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 32),
      child: Center(
        child: AppGlassCard(
          padding: const EdgeInsets.fromLTRB(25, 28, 25, 25),
          radius: 25,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 700),
                curve: Curves.elasticOut,
                tween: Tween(begin: .75, end: 1),
                builder: (_, value, child) {
                  return Transform.scale(scale: value, child: child);
                },
                child: Container(
                  width: 84,
                  height: 84,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary.withValues(alpha: .08),
                        AppColors.secondary.withValues(alpha: .10),
                      ],
                    ),
                  ),
                  child: Icon(
                    Icons.restaurant_menu_rounded,
                    size: 38,
                    color: AppColors.primary,
                  ),
                ),
              ),

              const SizedBox(height: 18),

              const Text(
                'مفيش منتجات متاحة',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
              ),

              const SizedBox(height: 7),

              Text(
                'جرب قسم تاني وشوف الاختيارات المتاحة.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11.5,
                  height: 1.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
