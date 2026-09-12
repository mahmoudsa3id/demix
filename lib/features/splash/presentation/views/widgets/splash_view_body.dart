import 'package:demix/constants/assets.dart';
import 'package:demix/core/routing/router_names.dart';
import 'package:demix/features/splash/presentation/views/widgets/splash_progress_pointer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class SplashViewBody extends StatefulWidget {
  const SplashViewBody({super.key});

  @override
  State<SplashViewBody> createState() => _SplashViewBodyState();
}

class _SplashViewBodyState extends State<SplashViewBody>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    animationAndNavigate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: SvgPicture.asset(
            Assets.assetsSvgDemixSplash,
            fit: BoxFit.fill,
          ),
        ),

        Positioned(
          left: 0,
          right: 0,
          bottom: MediaQuery.sizeOf(context).height * .10,
          child: Center(
            child: SizedBox(
              width: MediaQuery.sizeOf(context).width * .58,
              height: 20,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return CustomPaint(
                    painter: SplashProgressPainter(progress: _controller.value),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  void animationAndNavigate() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (!mounted) return;

        context.go(RoutePaths.onboarding);
      }
    });

    _controller.forward();
  }
}
