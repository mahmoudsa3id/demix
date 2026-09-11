import 'package:demix/core/theme/app_colors.dart';
import 'package:demix/features/home/presentation/views/widgets/demix_curve_painters.dart';
import 'package:flutter/material.dart';

class DemixLogo extends StatelessWidget {
  const DemixLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      height: 85,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: -20,
            top: 0,
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
                child: const Text(
                  'D',
                  style: TextStyle(
                    fontSize: 78,
                    height: .9,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            left: 27,
            top: 2,
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
                child: const Text(
                  'e',
                  style: TextStyle(
                    fontSize: 78,
                    height: .9,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ),

          const Positioned(
            left: 70,
            top: 2,
            child: Text(
              'mix',
              style: TextStyle(
                fontSize: 78,
                height: .9,
                letterSpacing: -3,
                fontWeight: FontWeight.w900,
                color: Colors.black,
              ),
            ),
          ),

          Positioned(
            left: 28,
            top: 60,
            child: SizedBox(
              width: 200,
              height: 40,
              child: CustomPaint(painter: DemixCurvePainterLogo()),
            ),
          ),
        ],
      ),
    );
  }
}
