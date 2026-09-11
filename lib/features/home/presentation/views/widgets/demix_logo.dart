import 'package:demix/core/theme/app_colors.dart';
import 'package:demix/features/home/presentation/views/widgets/demix_curve_painters.dart';
import 'package:flutter/material.dart';

class DemixLogo extends StatelessWidget {
  const DemixLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 50,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // D
          Positioned(
            left: 0,
            top: -1,
            child: Transform.rotate(
              angle: -0.08,
              child: ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (bounds) {
                  return const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.primaryLight, AppColors.secondary],
                  ).createShader(bounds);
                },
                child: Text(
                  'D',
                  style: TextStyle(
                    fontSize: 30,
                    height: .9,
                    letterSpacing: -2.2,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ),

          // e
          Positioned(
            left: 18,
            top: 1,
            child: Transform.rotate(
              angle: -0.035,
              child: ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (bounds) {
                  return const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.primaryLight, AppColors.secondary],
                  ).createShader(bounds);
                },
                child: Text(
                  'e',
                  style: TextStyle(
                    fontSize: 30,
                    height: .9,
                    letterSpacing: -2.2,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ),

          // m
          Positioned(
            left: 35,
            top: 1,

            child: Text(
              'm',
              style: TextStyle(
                fontSize: 30,
                height: .9,
                letterSpacing: -2.2,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),

          // i
          Positioned(
            left: 60,
            top: 1,
            child: Text(
              'i',
              style: TextStyle(
                fontSize: 30,
                height: .9,
                letterSpacing: -2.2,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),

          // x
          Positioned(
            left: 69,
            top: 1,
            child: Text(
              'x',
              style: TextStyle(
                fontSize: 30,
                height: .9,
                letterSpacing: -2.2,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),

          // Curve
          Positioned(
            left: 16,
            top: 28,
            child: SizedBox(
              width: 48,
              height: 10,
              child: CustomPaint(painter: DemixCurvePainter()),
            ),
          ),
        ],
      ),
    );
  }
}
