import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    fontFamily: 'Cairo',

    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.surface,
    ),

    textTheme: const TextTheme(
      bodyLarge: AppTextStyles.cairoRegular,
      bodyMedium: AppTextStyles.cairoRegular,
      titleLarge: AppTextStyles.cairoBold,
      titleMedium: AppTextStyles.cairoSemiBold,
    ),
  );
}
