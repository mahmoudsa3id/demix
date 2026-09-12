import 'package:demix/constants/assets.dart';
import 'package:demix/core/routing/router_names.dart';
import 'package:demix/features/auth/presentation/views/widgets/auth_gradient_bottun.dart';
import 'package:demix/features/auth/presentation/views/widgets/demix_logo.dart';
import 'package:demix/features/onboarding/presentation/widgets/onboarding_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class OnboardingViewBody extends StatefulWidget {
  const OnboardingViewBody({super.key});

  @override
  State<OnboardingViewBody> createState() => _OnboardingViewBodyState();
}

class _OnboardingViewBodyState extends State<OnboardingViewBody> {
  final PageController _pageController = PageController();

  int currentPage = 0;

  final List<String> images = [
    Assets.assetsSvgFood,
    Assets.assetsSvgDrinks,
    Assets.assetsSvgDeliveryRider,
  ];

  final List<String> titles = [
    'Made for your cravings.',
    'Sip your mood.',
    'On the way to you.',
  ];

  final List<String> descriptions = [
    'Big flavors. Zero compromises.',
    'Something refreshing is always a good idea.',
    'Hot. Fresh. Right on time.',
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void nextPage() {
    if (currentPage == images.length - 1) {
      context.go(RoutePaths.login);
      return;
    }

    _pageController.nextPage(
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOutCubic,
    );
  }

  void skip() {
    context.go(RoutePaths.login);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: .spaceAround,
              children: [
                const DemixLogo(),

                TextButton(
                  onPressed: skip,
                  child: const Text(
                    'Skip',
                    style: TextStyle(
                      color: Color(0xFF66616A),
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: images.length,
                onPageChanged: (index) {
                  setState(() {
                    currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Expanded(
                        child: TweenAnimationBuilder<double>(
                          tween: Tween(begin: .88, end: 1),
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.easeOutBack,
                          builder: (context, value, child) {
                            return Transform.scale(scale: value, child: child);
                          },
                          child: SvgPicture.asset(
                            images[index],
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      Text(
                        titles[index],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 31,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF111018),
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        descriptions[index],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF77727C),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            OnboardingIndicator(currentPage: currentPage, count: images.length),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: AuthGradientButton(
                onTap: nextPage,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      currentPage == images.length - 1
                          ? 'Get Started'
                          : 'Continue',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(width: 10),

                    const Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
