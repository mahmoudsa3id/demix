import 'dart:math' as math;

import 'package:demix/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AnimatedRider extends StatelessWidget {
  final String image;
  final AnimationController controller;

  const AnimatedRider({
    super.key,
    required this.image,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final t = controller.value;

        double x = 0;
        double y = 0;
        double rotation = 0;

        // ==========================================
        // Enter from right
        // ==========================================

        if (t < .58) {
          final progress = Curves.easeOutCubic.transform(t / .58);

          x = 330 * (1 - progress);

          y = math.sin(progress * math.pi * 5) * 2.5;
        }
        // ==========================================
        // Stop
        // ==========================================
        else if (t < .68) {
          final progress = (t - .58) / .10;

          x = 0;

          y = -math.sin(progress * math.pi) * 4;
        }
        // ==========================================
        // Wheelie
        // ==========================================
        else if (t < .82) {
          final progress = Curves.easeOut.transform((t - .68) / .14);

          x = 0;
          y = -15 * progress;
          rotation = -.10 * progress;
        }
        // ==========================================
        // Landing
        // ==========================================
        else if (t < .94) {
          final progress = Curves.easeOut.transform((t - .82) / .12);

          x = 0;
          y = -15 * (1 - progress);
          rotation = -.10 * (1 - progress);
        }
        // ==========================================
        // Suspension bounce
        // ==========================================
        else {
          final progress = (t - .94) / .06;

          x = 0;

          y = -math.sin(progress * math.pi) * 3;
        }

        return Transform.translate(
          offset: Offset(x, y),
          child: Transform.rotate(
            angle: rotation,
            child: Transform.scale(scale: 1.02, child: child),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: SvgPicture.asset(image, fit: BoxFit.contain),
      ),
    );
  }
}
