import 'package:flutter/material.dart';

class AppRadius {
  // Small radius
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;

  // Medium radius
  static const double lg = 16.0;
  static const double xl = 20.0;

  // Large radius
  static const double xxl = 24.0;
  static const double xxxl = 32.0;

  // Extra large radius
  static const double full = 999.0;

  // BorderRadius presets
  static const BorderRadius borderRadiusExtraSmall = BorderRadius.all(
    Radius.circular(xs),
  );

  static const BorderRadius borderRadiusSmall = BorderRadius.all(
    Radius.circular(sm),
  );

  static const BorderRadius borderRadiusMedium = BorderRadius.all(
    Radius.circular(md),
  );

  static const BorderRadius borderRadiusLarge = BorderRadius.all(
    Radius.circular(lg),
  );

  static const BorderRadius borderRadiusXL = BorderRadius.all(
    Radius.circular(xl),
  );

  static const BorderRadius borderRadiusXXL = BorderRadius.all(
    Radius.circular(xxl),
  );

  static const BorderRadius borderRadiusCircular = BorderRadius.all(
    Radius.circular(full),
  );

  // Top border radius
  static const BorderRadius borderRadiusTopLarge = BorderRadius.only(
    topLeft: Radius.circular(xxl),
    topRight: Radius.circular(xxl),
  );

  static const BorderRadius borderRadiusTopXL = BorderRadius.only(
    topLeft: Radius.circular(xxxl),
    topRight: Radius.circular(xxxl),
  );

  // Bottom border radius
  static const BorderRadius borderRadiusBottomLarge = BorderRadius.only(
    bottomLeft: Radius.circular(xxl),
    bottomRight: Radius.circular(xxl),
  );

  static const BorderRadius borderRadiusBottomXL = BorderRadius.only(
    bottomLeft: Radius.circular(xxxl),
    bottomRight: Radius.circular(xxxl),
  );
}
