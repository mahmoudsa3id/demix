import 'package:demix/constants/assets.dart';
import 'package:demix/core/db/shared_preferance.dart';
import 'package:demix/core/routing/router_names.dart';
import 'package:demix/core/theme/app_colors.dart';
import 'package:demix/core/theme/app_spacing.dart';
import 'package:demix/core/theme/app_text_styles.dart';
import 'package:demix/features/onboarding/presentation/widgets/language_dialog.dart';
import 'package:demix/features/onboarding/presentation/widgets/logo_wave_clipper.dart';
import 'package:demix/features/onboarding/presentation/widgets/onboarding_page_view.dart';
import 'package:demix/features/onboarding/presentation/widgets/top_wave_clipper.dart';
import 'package:demix/generated/l10n.dart';
import 'package:demix/features/auth/presentation/views/widgets/auth_gradient_bottun.dart';
import 'package:demix/features/auth/presentation/views/widgets/demix_logo.dart';
import 'package:demix/features/onboarding/presentation/widgets/onboarding_indicator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingViewBody extends StatefulWidget {
  const OnboardingViewBody({super.key});

  @override
  State<OnboardingViewBody> createState() => _OnboardingViewBodyState();
}

class _OnboardingViewBodyState extends State<OnboardingViewBody>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();

  late final AnimationController _pageAnimationController;
  late final AnimationController _riderController;

  int currentPage = 0;

  final List<String> images = [
    Assets.assetsSvgFood,
    Assets.assetsSvgDrinks,
    Assets.assetsSvgDeliveryRider,
  ];

  @override
  void initState() {
    super.initState();

    _pageAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    )..forward();

    _riderController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      _showLanguageDialog();
    });
  }

  @override
  void dispose() {
    _pageAnimationController.dispose();
    _riderController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  // ============================================================
  // Navigation
  // ============================================================

  Future<void> nextPage() async {
    if (currentPage == images.length - 1) {
      await SharedPreference.setOnboarding(true);

      if (!mounted) return;

      context.go(RoutePaths.login);
      return;
    }

    await _pageController.nextPage(
      duration: const Duration(milliseconds: 550),
      curve: Curves.easeOutCubic,
    );
  }

  Future<void> skip() async {
    await SharedPreference.setOnboarding(true);

    if (!mounted) return;

    context.go(RoutePaths.login);
  }

  // ============================================================
  // Page Change
  // ============================================================

  void _onPageChanged(int index) {
    setState(() {
      currentPage = index;
    });

    _pageAnimationController
      ..reset()
      ..forward();

    if (index == 2) {
      _riderController
        ..reset()
        ..forward();
    } else {
      _riderController
        ..stop()
        ..reset();
    }
  }

  // ============================================================
  // Language Dialog
  // ============================================================

  void _showLanguageDialog() {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'Language',
      barrierColor: Colors.black.withValues(alpha: .60),
      transitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (context, animation, secondaryAnimation) {
        return const LanguageDialog();
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
        );

        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(scale: curved, child: child),
        );
      },
    );
  }

  // ============================================================
  // Build
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    final List<String> titles = [
      s.onboardingFoodTitle,
      s.onboardingDrinksTitle,
      s.onboardingDeliveryTitle,
    ];

    final List<String> descriptions = [
      s.onboardingFoodDescription,
      s.onboardingDrinksDescription,
      s.onboardingDeliveryDescription,
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // ======================================================
          // Top Gradient Wave
          // ======================================================
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.sizeOf(context).height * .57,
            child: ClipPath(
              clipper: TopWaveClipper(),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primary,
                      AppColors.secondary,
                      AppColors.primaryDark,
                    ],
                  ),
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 8),

                // ==================================================
                // Header
                // ==================================================
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 70),
                  child: Row(
                    children: [
                      // استخدم اللوجو الرسمي بتاعك
                      // وخليه أبيض / واضح من داخل DemixLogo نفسه
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: -0.08, end: -0.025),
                        duration: const Duration(milliseconds: 700),
                        curve: Curves.easeOutBack,
                        builder: (context, angle, child) {
                          return Transform.rotate(angle: angle, child: child);
                        },
                        child: SizedBox(
                          width: 220,
                          child: ClipPath(
                            clipper: LogoWaveClipper(),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 11,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withValues(
                                      alpha: .18,
                                    ),
                                    blurRadius: 22,
                                    spreadRadius: 1,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                child: const DemixLogo(),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const Spacer(),

                      if (currentPage != images.length - 1)
                        GestureDetector(
                          onTap: skip,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 17,
                              vertical: 9,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: .18),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: .20),
                              ),
                            ),
                            child: Text(
                              s.onboardingSkip,
                              style: AppTextStyles.cairoSemiBold.copyWith(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.sm16),

                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: images.length,
                    physics: const BouncingScrollPhysics(),
                    onPageChanged: _onPageChanged,
                    itemBuilder: (context, index) {
                      return AnimatedBuilder(
                        animation: _pageAnimationController,
                        builder: (context, child) {
                          final animation = CurvedAnimation(
                            parent: _pageAnimationController,
                            curve: Curves.easeOutCubic,
                          );

                          return FadeTransition(
                            opacity: animation,
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0, .06),
                                end: Offset.zero,
                              ).animate(animation),
                              child: child,
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: OnboardingPageView(
                            index: index,
                            image: images[index],
                            title: titles[index],
                            description: descriptions[index],
                            riderController: _riderController,
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: AppSpacing.xs8),

                OnboardingIndicator(
                  currentPage: currentPage,
                  count: images.length,
                ),

                const SizedBox(height: AppSpacing.md24),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xs4,
                  ),
                  child: AuthGradientButton(
                    onTap: nextPage,
                    child: Text(
                      currentPage == images.length - 1
                          ? s.onboardingGetStarted
                          : s.onboardingContinue,
                      style: AppTextStyles.button.copyWith(fontSize: 17),
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.md),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
