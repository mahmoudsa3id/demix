import 'package:demix/core/theme/app_colors.dart';
import 'package:demix/core/theme/app_radius.dart';
import 'package:demix/core/theme/app_spacing.dart';
import 'package:demix/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class LanguageButton extends StatelessWidget {
  final String title;
  final String icon;
  final VoidCallback onTap;

  const LanguageButton({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.borderRadiusLarge,
      child: Container(
        width: double.infinity,
        height: 58,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: AppRadius.borderRadiusLarge,
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 23)),

            const SizedBox(width: AppSpacing.sm),

            Expanded(
              child: Text(
                title,
                style: AppTextStyles.cairoSemiBold.copyWith(
                  fontSize: 16,
                  color: AppColors.textPrimary,
                ),
              ),
            ),

            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 15,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
