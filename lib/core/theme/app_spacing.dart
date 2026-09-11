import 'package:flutter/material.dart';

class AppSpacing {
  // Extra small
  static const double xs2 = 2.0;
  static const double xs3 = 3.0;
  static const double xs4 = 4.0;
  static const double xs6 = 6.0;
  static const double xs8 = 8.0;

  // Small
  static const double sm = 12.0;
  static const double sm16 = 16.0;

  // Medium
  static const double md = 20.0;
  static const double md24 = 24.0;

  // Large
  static const double lg = 32.0;
  static const double lg40 = 40.0;

  // Extra large
  static const double xl = 48.0;
  static const double xl56 = 56.0;

  // Padding presets
  static const EdgeInsets paddingExtraSmall = EdgeInsets.all(xs8);
  static const EdgeInsets paddingSmall = EdgeInsets.all(sm);
  static const EdgeInsets paddingMedium = EdgeInsets.all(md);
  static const EdgeInsets paddingLarge = EdgeInsets.all(lg);

  // Horizontal padding
  static const EdgeInsets paddingHorizontalSmall = EdgeInsets.symmetric(
    horizontal: sm,
  );
  static const EdgeInsets paddingHorizontalMedium = EdgeInsets.symmetric(
    horizontal: md,
  );
  static const EdgeInsets paddingHorizontalLarge = EdgeInsets.symmetric(
    horizontal: lg,
  );

  // Vertical padding
  static const EdgeInsets paddingVerticalSmall = EdgeInsets.symmetric(
    vertical: sm,
  );
  static const EdgeInsets paddingVerticalMedium = EdgeInsets.symmetric(
    vertical: md,
  );
  static const EdgeInsets paddingVerticalLarge = EdgeInsets.symmetric(
    vertical: lg,
  );

  // Section spacing (vertical gap between sections)
  static const double sectionGap = 20.0;
  static const double sectionGapLarge = 32.0;

  // Card/Component spacing
  static const double cardGap = 12.0;
  static const double componentSpacing = 16.0;
}
