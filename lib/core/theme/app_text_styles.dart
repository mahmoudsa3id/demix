import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Typography for the deMüX dark UI.
/// Font family: Cairo
/// Make sure Cairo is registered in pubspec.yaml.
class AppTextStyles {
  AppTextStyles._();

  // ───────────────────────────────────────────────
  // Cairo weights
  // ─────────────────────────────────────────────

  static const TextStyle cairoThin = TextStyle(fontWeight: FontWeight.w100);

  static const TextStyle cairoExtraLight = TextStyle(
    fontWeight: FontWeight.w200,
  );

  static const TextStyle cairoLight = TextStyle(fontWeight: FontWeight.w300);

  static const TextStyle cairoRegular = TextStyle(fontWeight: FontWeight.w400);

  static const TextStyle cairoMedium = TextStyle(fontWeight: FontWeight.w500);

  static const TextStyle cairoSemiBold = TextStyle(fontWeight: FontWeight.w600);

  static const TextStyle cairoBold = TextStyle(fontWeight: FontWeight.w700);

  static const TextStyle cairoExtraBold = TextStyle(
    fontWeight: FontWeight.w800,
  );

  static const TextStyle cairoBlack = TextStyle(fontWeight: FontWeight.w900);

  // ─────────────────────────────────────────────
  // UI styles based on the supplied design
  // ─────────────────────────────────────────────

  static const TextStyle heroTitle = TextStyle(
    fontSize: 32,
    height: 1.2,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
  );

  static const TextStyle heroSubtitle = TextStyle(
    fontSize: 20,
    height: 1.35,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
  );

  static const TextStyle button = TextStyle(
    fontSize: 16,
    height: 1.2,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle sectionTitle = TextStyle(
    fontSize: 22,
    height: 1.3,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
  );

  static const TextStyle sectionAction = TextStyle(
    fontSize: 16,
    height: 1.2,
    fontWeight: FontWeight.w700,
    color: AppColors.secondary,
  );

  static const TextStyle category = TextStyle(
    fontSize: 14,
    height: 1.2,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle restaurantName = TextStyle(
    fontSize: 18,
    height: 1.25,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
  );

  static const TextStyle rating = TextStyle(
    fontSize: 14,
    height: 1.2,
    fontWeight: FontWeight.w700,
    color: Colors.amber, // Keep the star color as amber
  );

  static const TextStyle restaurantMeta = TextStyle(
    fontSize: 13,
    height: 1.3,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  static const TextStyle discount = TextStyle(
    fontSize: 13,
    height: 1.2,
    fontWeight: FontWeight.w700,
    color: AppColors.accent,
  );

  static const TextStyle deliveryTitle = TextStyle(
    fontSize: 24,
    height: 1.2,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
  );

  static const TextStyle deliverySubtitle = TextStyle(
    fontSize: 16,
    height: 1.2,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  static const TextStyle bottomNav = TextStyle(
    fontSize: 12,
    height: 1.2,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
  );

  static const TextStyle bottomNavSelected = TextStyle(
    fontSize: 12,
    height: 1.2,
    fontWeight: FontWeight.w800,
    color: AppColors.secondary,
  );

  static const TextStyle searchHint = TextStyle(
    fontSize: 16,
    height: 1.2,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static const TextStyle location = TextStyle(
    fontSize: 18,
    height: 1.2,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle locationLabel = TextStyle(
    fontSize: 16,
    height: 1.2,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );
}
