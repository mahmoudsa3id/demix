import 'package:flutter/material.dart';

class AppColors {
  // ================================
  // PRIMARY PALETTE
  // ================================
  static const Color primary = Color(0xFF7B00FF); // Purple
  static const Color primaryLight = Color(0xFF9D3FFF);
  static const Color primaryDark = Color(0xFF5D00CC);

  // ================================
  // SECONDARY PALETTE
  // ================================
  static const Color secondary = Color(0xFFFF7A00); // Orange
  static const Color secondaryLight = Color(0xFFFF9B3D);
  static const Color secondaryDark = Color(0xFFCC6200);

  // ================================
  // ACCENT COLORS
  // ================================
  static const Color accent = Color(0xFFFFC400); // Yellow
  static const Color success = Color(0xFF10B981); // Green
  static const Color error = Color(0xFFEF4444); // Red
  static const Color warning = Color(0xFFF59E0B); // Amber
  static const Color info = Color(0xFF3B82F6); // Blue

  // ================================
  // NEUTRAL PALETTE
  // ================================
  static const Color background = Color(0xFF07070B); // Darkest
  static const Color surface = Color(0xFF111118); // Dark
  static const Color surfaceLight = Color(0xFF1A1B24); // Slightly lighter
  static const Color surfaceLight2 = Color(0xFF23252E); // Even lighter

  // ================================
  // TEXT COLORS
  // ================================
  static const Color textPrimary = Color(0xFFFFFFFF); // White
  static const Color textSecondary = Color(0xFF9B9BA5); // Gray
  static const Color textTertiary = Color(0xFF6B6B75); // Darker gray
  static const Color textMuted = Color(0xFF4B4B55); // Very dark gray

  // ================================
  // BORDER & DIVIDER
  // ================================
  static Color border = Color(0xFF9B9BA5).withOpacity(0.2);
  static const Color divider = Color(0xFF1F1F28);

  // ================================
  // STATES
  // ================================
  static const Color disabled = Color(0xFF4B4B55);
  static const Color disabledBackground = Color(0xFF1A1B24);

  // ================================
  // SEMANTIC COLORS
  // ================================
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  // ================================
  // SHADOW
  // ================================
  static const Color shadow = Color(0x1F000000);
  static const Color shadowDark = Color(0x3F000000);
}
