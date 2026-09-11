import 'package:flutter/material.dart';

class AppTypography {
  static const String _cairoArabic = 'cairo';
  static const String _interEnglish = 'inter';

  // Display styles
  static const TextStyle displayLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    height: 1.25,
    fontFamily: _cairoArabic,
  );

  static const TextStyle displayMedium = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    height: 1.3,
    fontFamily: _cairoArabic,
  );

  static const TextStyle displaySmall = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    height: 1.35,
    fontFamily: _cairoArabic,
  );

  // Heading styles
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    height: 1.36,
    fontFamily: _cairoArabic,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 1.4,
    fontFamily: _cairoArabic,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    height: 1.44,
    fontFamily: _cairoArabic,
  );

  // Title styles
  static const TextStyle titleLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.5,
    fontFamily: _cairoArabic,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.57,
    fontFamily: _cairoArabic,
  );

  static const TextStyle titleSmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.67,
    fontFamily: _cairoArabic,
  );

  // Body styles
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    fontFamily: _cairoArabic,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.57,
    fontFamily: _cairoArabic,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.67,
    fontFamily: _cairoArabic,
  );

  // Label/Caption styles
  static const TextStyle labelLarge = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.67,
    fontFamily: _cairoArabic,
    letterSpacing: 0.5,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    height: 1.73,
    fontFamily: _cairoArabic,
    letterSpacing: 0.4,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    height: 1.8,
    fontFamily: _cairoArabic,
    letterSpacing: 0.3,
  );

  // Button styles
  static const TextStyle button = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.57,
    fontFamily: _cairoArabic,
    letterSpacing: 0.1,
  );

  // Price/highlight styles
  static const TextStyle price = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    height: 1.44,
    fontFamily: _cairoArabic,
  );

  static const TextStyle priceSmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.57,
    fontFamily: _cairoArabic,
  );

  // Utility: Get appropriate font family based on language
  static String getFontFamily(bool isArabic) {
    return isArabic ? _cairoArabic : _interEnglish;
  }
}
