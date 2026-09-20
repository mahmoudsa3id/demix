import 'package:demix/core/di/injection.dart';
import 'package:demix/core/routing/navigation.dart';
import 'package:demix/core/routing/route_paths.dart';
import 'package:demix/core/widgets/bottom_nav.dart';

import 'package:demix/features/account/presentation/view/about_view.dart';
import 'package:demix/features/account/presentation/view/edit_profile_view.dart';
import 'package:demix/features/account/presentation/view/language_view.dart';
import 'package:demix/features/account/presentation/view/notification_view.dart';
import 'package:demix/features/account/presentation/view/privacy_view.dart';
import 'package:demix/features/account/presentation/view/profile_view.dart';
import 'package:demix/features/account/presentation/view/setting_view.dart';
import 'package:demix/features/account/presentation/view/support_view.dart';
import 'package:demix/features/account/presentation/view/terms_view.dart';

import 'package:demix/features/auth/presentation/views/forget_password_view.dart';
import 'package:demix/features/auth/presentation/views/login_view.dart';
import 'package:demix/features/auth/presentation/views/sign_up_view.dart';
import 'package:demix/features/business/domain/entities/product.dart';
import 'package:demix/features/business/presentation/cubit/business_profile_cubit.dart';
import 'package:demix/features/business/presentation/cubit/business_profile_state.dart';

import 'package:demix/features/business/presentation/pages/business_profile_view.dart';
import 'package:demix/features/business/presentation/pages/business_view.dart';

import 'package:demix/features/cart/presentation/pages/cart_page.dart';

import 'package:demix/features/checkout/presentation/pages/checkout_location_picker_page.dart';
import 'package:demix/features/checkout/presentation/pages/checkout_page.dart';
import 'package:demix/features/favorite/domain/entities/favourite_entity.dart';

import 'package:demix/features/favorite/presentation/view/favorite_view.dart';

import 'package:demix/features/home/presentation/views/home_view.dart';

import 'package:demix/features/location/presentation/cubit/location_cubit.dart';
import 'package:demix/features/location/presentation/views/location_page.dart';
import 'package:demix/features/location/presentation/views/saved_location_page.dart';

import 'package:demix/features/onboarding/presentation/onboarding_view.dart';

import 'package:demix/features/orders/presentation/pages/order_details_view.dart';
import 'package:demix/features/orders/presentation/pages/order_success_view.dart';
import 'package:demix/features/orders/presentation/pages/orders_view.dart';

import 'package:demix/features/product_ordering/presentation/pages/product_details_page.dart';

import 'package:demix/features/splash/presentation/views/splash_view.dart';

import 'package:demix/generated/l10n.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'dart:ui';

class AppRouter {
  AppRouter._();

  static late final GoRouter router;

  // ============================================================
  // TRANSITION TYPE
  // ============================================================

  static _TransitionType _transitionType(String? routeName) {
    switch (routeName) {
      case 'product':
        return _TransitionType.product;

      case 'restaurant':
        return _TransitionType.restaurant;

      case 'category':
        return _TransitionType.category;

      case 'cart':
        return _TransitionType.cart;

      case 'checkout':
        return _TransitionType.checkout;

      case 'checkout-location':
        return _TransitionType.location;

      case 'location':
        return _TransitionType.location;

      case 'order-success':
        return _TransitionType.success;

      case 'order-details':
        return _TransitionType.details;

      case 'login':
      case 'signup':
      case 'forgot-password':
        return _TransitionType.auth;

      case 'settings':
      case 'language':
      case 'notifications':
      case 'privacy':
      case 'terms':
      case 'support':
      case 'about':
      case 'edit-profile':
      case 'offers':
        return _TransitionType.panel;

      case 'home':
      case 'orders':
      case 'favorites':
      case 'profile':
        return _TransitionType.tab;

      default:
        return _TransitionType.cinematic;
    }
  }

  // ============================================================
  // GLOBAL TRANSITION
  // ============================================================

  static Page<void> _animatedPage({
    required GoRouterState state,
    required Widget child,
  }) {
    final type = _transitionType(state.name);

    Duration duration;
    Duration reverseDuration;

    switch (type) {
      case _TransitionType.product:
        duration = const Duration(milliseconds: 700);
        reverseDuration = const Duration(milliseconds: 500);
        break;

      case _TransitionType.restaurant:
        duration = const Duration(milliseconds: 680);
        reverseDuration = const Duration(milliseconds: 480);
        break;

      case _TransitionType.cart:
        duration = const Duration(milliseconds: 620);
        reverseDuration = const Duration(milliseconds: 450);
        break;

      case _TransitionType.success:
        duration = const Duration(milliseconds: 850);
        reverseDuration = const Duration(milliseconds: 500);
        break;

      case _TransitionType.auth:
        duration = const Duration(milliseconds: 650);
        reverseDuration = const Duration(milliseconds: 450);
        break;

      default:
        duration = const Duration(milliseconds: 560);
        reverseDuration = const Duration(milliseconds: 400);
    }

    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,

      transitionDuration: duration,
      reverseTransitionDuration: reverseDuration,

      transitionsBuilder: (context, animation, secondaryAnimation, pageChild) {
        return _MotionBuilder(
          type: type,
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          child: pageChild,
        );
      },
    );
  }

  // ============================================================
  // SPLASH
  // ============================================================

  static Page<void> _splashPage({
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,

      transitionDuration: const Duration(milliseconds: 1100),

      reverseTransitionDuration: const Duration(milliseconds: 600),

      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curve = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
        );

        final scale = Tween<double>(begin: .62, end: 1).animate(curve);

        final rotation = Tween<double>(begin: -.055, end: 0).animate(curve);

        final fade = CurvedAnimation(parent: animation, curve: Curves.easeOut);

        return FadeTransition(
          opacity: fade,
          child: AnimatedBuilder(
            animation: animation,
            builder: (_, child) {
              final blur = Tween<double>(
                begin: 10,
                end: 0,
              ).transform(animation.value);

              return ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
                child: Transform.rotate(
                  angle: rotation.value,
                  child: Transform.scale(scale: scale.value, child: child),
                ),
              );
            },
            child: child,
          ),
        );
      },
    );
  }

  // ============================================================
  // INITIALIZE
  // ============================================================

  static void initialize() {
    router = GoRouter(
      initialLocation: RoutePaths.splash,

      // ========================================================
      // ERROR
      // ========================================================
      errorBuilder: (context, state) {
        return DemixErrorView(error: state);
      },

      // ========================================================
      // ROUTES
      // ========================================================
      routes: [
        // ======================================================
        // SPLASH
        // ======================================================
        GoRoute(
          path: RoutePaths.splash,
          name: 'splash',
          pageBuilder: (context, state) {
            return _splashPage(state: state, child: const SplashView());
          },
        ),

        // ======================================================
        // MAIN APP
        // ======================================================
        ShellRoute(
          builder: (context, state, child) {
            return Scaffold(
              body: child,
              bottomNavigationBar: BottomNav(s: S.of(context)),
            );
          },

          routes: [
            // ==================================================
            // HOME
            // ==================================================
            GoRoute(
              path: RoutePaths.home,
              name: 'home',
              pageBuilder: (context, state) {
                return _animatedPage(state: state, child: const HomeView());
              },
            ),

            // ==================================================
            // ORDERS
            // ==================================================
            GoRoute(
              path: RoutePaths.orders,
              name: 'orders',
              pageBuilder: (context, state) {
                return _animatedPage(state: state, child: const OrdersView());
              },
            ),

            // ==================================================
            // FAVORITES
            // ==================================================
            GoRoute(
              path: RoutePaths.favorites,
              name: 'favorites',
              pageBuilder: (context, state) {
                return _animatedPage(
                  state: state,
                  child: const FavoritesView(),
                );
              },
            ),

            // ==================================================
            // PROFILE
            // ==================================================
            GoRoute(
              path: RoutePaths.profile,
              name: 'profile',
              pageBuilder: (context, state) {
                return _animatedPage(state: state, child: ProfileView());
              },
            ),
          ],
        ),

        // ======================================================
        // EDIT PROFILE
        // ======================================================
        GoRoute(
          path: RoutePaths.editProfile,
          name: 'edit-profile',
          pageBuilder: (context, state) {
            return _animatedPage(state: state, child: const EditProfileView());
          },
        ),

        // ======================================================
        // CART
        // ======================================================
        GoRoute(
          path: RoutePaths.cart,
          name: 'cart',
          pageBuilder: (context, state) {
            return _animatedPage(state: state, child: const CartPage());
          },
        ),

        // ======================================================
        // SETTINGS
        // ======================================================
        GoRoute(
          path: RoutePaths.settings,
          name: 'settings',
          pageBuilder: (context, state) {
            return _animatedPage(state: state, child: const SettingsView());
          },
        ),

        // ======================================================
        // LANGUAGE
        // ======================================================
        GoRoute(
          path: RoutePaths.language,
          name: 'language',
          pageBuilder: (context, state) {
            return _animatedPage(state: state, child: const LanguageView());
          },
        ),

        // ======================================================
        // NOTIFICATIONS
        // ======================================================
        GoRoute(
          path: RoutePaths.notifications,
          name: 'notifications',
          pageBuilder: (context, state) {
            return _animatedPage(
              state: state,
              child: const NotificationsView(),
            );
          },
        ),

        // ======================================================
        // PRIVACY
        // ======================================================
        GoRoute(
          path: RoutePaths.privacy,
          name: 'privacy',
          pageBuilder: (context, state) {
            return _animatedPage(state: state, child: const PrivacyView());
          },
        ),

        // ======================================================
        // TERMS
        // ======================================================
        GoRoute(
          path: RoutePaths.terms,
          name: 'terms',
          pageBuilder: (context, state) {
            return _animatedPage(state: state, child: const TermsView());
          },
        ),

        // ======================================================
        // SUPPORT
        // ======================================================
        GoRoute(
          path: RoutePaths.support,
          name: 'support',
          pageBuilder: (context, state) {
            return _animatedPage(state: state, child: const SupportView());
          },
        ),

        // ======================================================
        // ABOUT
        // ======================================================
        GoRoute(
          path: RoutePaths.about,
          name: 'about',
          pageBuilder: (context, state) {
            return _animatedPage(state: state, child: const AboutView());
          },
        ),

        // ======================================================
        // CATEGORY
        // ======================================================
        GoRoute(
          path: RoutePaths.category,
          name: 'category',
          pageBuilder: (context, state) {
            final type = state.pathParameters['categoryId'] ?? 'restaurant';

            return _animatedPage(
              state: state,
              child: BusinessView(type: type),
            );
          },
        ),

        // ======================================================
        // RESTAURANT / CAFE
        // ======================================================
        GoRoute(
          path: RoutePaths.restaurant,
          name: 'restaurant',
          pageBuilder: (context, state) {
            final restaurantId = state.pathParameters['restaurantId']!;

            return _animatedPage(
              state: state,
              child: BusinessProfileView(businessId: restaurantId),
            );
          },
        ),
        GoRoute(
          path: RoutePaths.savedLocations,
          name: 'saved-locations',
          pageBuilder: (context, state) {
            return _animatedPage(
              state: state,
              child: const SavedLocationsView(),
            );
          },
        ),
        // ======================================================
        // PRODUCT
        // ======================================================
        GoRoute(
          path: RoutePaths.product,
          name: 'product',
          pageBuilder: (context, state) {
            final extra = state.extra;

            // ============================================================
            // NORMAL PRODUCT NAVIGATION
            // ============================================================
            if (extra is ProductDetailsArguments) {
              return _animatedPage(
                state: state,
                child: ProductDetailsPage(arguments: extra),
              );
            }

            // ============================================================
            // PRODUCT FROM FAVORITES
            // ============================================================
            if (extra is FavoriteEntity) {
              final productId = extra.itemId.trim();
              final businessId = (extra.businessId ?? '').trim();

              if (productId.isEmpty || businessId.isEmpty) {
                return _animatedPage(
                  state: state,
                  child: const Scaffold(
                    body: Center(
                      child: Text(
                        'بيانات المنتج غير مكتملة',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                );
              }

              return _animatedPage(
                state: state,
                child: BlocProvider<BusinessProfileCubit>(
                  create: (_) {
                    return getIt<BusinessProfileCubit>()..load(businessId);
                  },
                  child: _FavoriteProductResolver(productId: productId),
                ),
              );
            }

            // ============================================================
            // INVALID EXTRA
            // ============================================================
            return _animatedPage(
              state: state,
              child: const Scaffold(
                body: Center(
                  child: Text(
                    'Product navigation data is invalid',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            );
          },
        ),

        // ======================================================
        // CHECKOUT
        // ======================================================
        GoRoute(
          path: RoutePaths.checkout,
          name: 'checkout',
          pageBuilder: (context, state) {
            final arguments = state.extra as CheckoutArguments;

            return _animatedPage(
              state: state,
              child: CheckoutPage(arguments: arguments),
            );
          },
        ),

        // ======================================================
        // CHECKOUT LOCATION
        // ======================================================
        GoRoute(
          path: RoutePaths.checkoutLocation,
          name: 'checkout-location',
          pageBuilder: (context, state) {
            return _animatedPage(
              state: state,
              child: const CheckoutLocationPickerPage(),
            );
          },
        ),

        // ======================================================
        // LOCATION
        // ======================================================
        GoRoute(
          path: RoutePaths.location,
          name: 'location',
          pageBuilder: (context, state) {
            return _animatedPage(
              state: state,
              child: BlocProvider<LocationCubit>(
                create: (_) {
                  return getIt<LocationCubit>()..initialize();
                },
                child: LocationPage(
                  onConfirmed: () async {
                    if (!context.mounted) {
                      return;
                    }

                    context.go(RoutePaths.home);
                  },
                ),
              ),
            );
          },
        ),

        // ======================================================
        // ONBOARDING
        // ======================================================
        GoRoute(
          path: RoutePaths.onboarding,
          name: 'onboarding',
          pageBuilder: (context, state) {
            return _animatedPage(state: state, child: const OnboardingView());
          },
        ),

        // ======================================================
        // LOGIN
        // ======================================================
        GoRoute(
          path: RoutePaths.login,
          name: 'login',
          pageBuilder: (context, state) {
            return _animatedPage(state: state, child: const LoginView());
          },
        ),

        // ======================================================
        // SIGN UP
        // ======================================================
        GoRoute(
          path: RoutePaths.signup,
          name: 'signup',
          pageBuilder: (context, state) {
            return _animatedPage(state: state, child: const SignupView());
          },
        ),

        // ======================================================
        // FORGOT PASSWORD
        // ======================================================
        GoRoute(
          path: RoutePaths.forgotPassword,
          name: 'forgot-password',
          pageBuilder: (context, state) {
            return _animatedPage(state: state, child: ForgotPasswordPage());
          },
        ),

        // ======================================================
        // ORDER SUCCESS
        // ======================================================
        GoRoute(
          path: RoutePaths.orderSuccess,
          name: 'order-success',
          pageBuilder: (context, state) {
            final orderId = state.pathParameters['orderId']!;

            final orderNumber = state.uri.queryParameters['orderNumber'] ?? '';

            return _animatedPage(
              state: state,
              child: OrderSuccessView(
                orderId: orderId,
                orderNumber: orderNumber,
              ),
            );
          },
        ),

        // ======================================================
        // ORDER DETAILS
        // ======================================================
        GoRoute(
          path: RoutePaths.orderDetailsById,
          name: 'order-details',
          pageBuilder: (context, state) {
            final orderId = state.pathParameters['orderId']!;

            return _animatedPage(
              state: state,
              child: OrderDetailsView(orderId: orderId),
            );
          },
        ),

        // ======================================================
        // OFFERS
        // ======================================================
        GoRoute(
          path: RoutePaths.offers,
          name: 'offers',
          pageBuilder: (context, state) {
            final isArabic =
                Localizations.localeOf(context).languageCode == 'ar';

            return _animatedPage(
              state: state,
              child: InformationView(
                title: isArabic ? 'العروض والكوبونات' : 'Coupons & Offers',
                description: isArabic
                    ? 'ستظهر هنا العروض والكوبونات المحفوظة.'
                    : 'Your saved offers and available coupons will appear here.',
                icon: Icons.local_offer_outlined,
              ),
            );
          },
        ),
      ],
    );
  }
}

// ============================================================
// MOTION TYPE
// ============================================================

enum _TransitionType {
  cinematic,
  tab,
  product,
  restaurant,
  category,
  cart,
  checkout,
  location,
  success,
  details,
  auth,
  panel,
}

// ============================================================
// MOTION BUILDER
// ============================================================

class _MotionBuilder extends StatelessWidget {
  const _MotionBuilder({
    required this.type,
    required this.animation,
    required this.secondaryAnimation,
    required this.child,
  });

  final _TransitionType type;
  final Animation<double> animation;
  final Animation<double> secondaryAnimation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final enter = CurvedAnimation(
      parent: animation,
      curve: _enterCurve,
      reverseCurve: Curves.easeInCubic,
    );

    final exit = CurvedAnimation(
      parent: secondaryAnimation,
      curve: Curves.easeOutCubic,
    );

    return AnimatedBuilder(
      animation: Listenable.merge([enter, exit]),
      builder: (context, child) {
        final params = _params(enter.value);

        // ========================================================
        // ENTER VALUES
        // ========================================================

        final enterX = params.x;
        final enterY = params.y;

        final enterScale = params.scale;

        final enterRotateX = params.rotateX;
        final enterRotateY = params.rotateY;
        final enterRotateZ = params.rotateZ;

        // ========================================================
        // EXIT VALUES
        // ========================================================

        final exitScale = Tween<double>(
          begin: 1.0,
          end: params.exitScale,
        ).transform(exit.value);

        final exitX = Tween<double>(
          begin: 0.0,
          end: params.exitX,
        ).transform(exit.value);

        final exitY = Tween<double>(
          begin: 0.0,
          end: params.exitY,
        ).transform(exit.value);

        final exitRotation = Tween<double>(
          begin: 0.0,
          end: params.exitRotation,
        ).transform(exit.value);

        // ========================================================
        // BLUR
        // ========================================================

        final blur = Tween<double>(
          begin: params.blurStart,
          end: 0.0,
        ).transform(enter.value);

        // ========================================================
        // OPACITY
        // ========================================================

        final enterOpacity = Tween<double>(
          begin: params.fadeStart,
          end: 1.0,
        ).transform(enter.value);

        final exitOpacity = Tween<double>(
          begin: 1.0,
          end: .90,
        ).transform(exit.value);

        final opacity = enterOpacity * exitOpacity;

        // ========================================================
        // COMBINED TRANSFORM
        // ========================================================

        final matrix = Matrix4.identity()
          ..setEntry(3, 2, params.perspective)
          ..translate(enterX + exitX, enterY + exitY)
          ..rotateX(enterRotateX)
          ..rotateY(enterRotateY)
          ..rotateZ(enterRotateZ + exitRotation)
          ..scale(enterScale * exitScale);

        Widget result = child!;

        // ========================================================
        // BLUR
        // ========================================================

        if (blur > 0.01) {
          result = ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
            child: result,
          );
        }

        // ========================================================
        // TRANSFORM
        // ========================================================

        result = Transform(
          alignment: Alignment.center,
          transform: matrix,
          child: result,
        );

        // ========================================================
        // OPACITY
        // ========================================================

        result = Opacity(opacity: opacity.clamp(0.0, 1.0), child: result);

        return result;
      },
      child: child,
    );
  }

  Curve get _enterCurve {
    switch (type) {
      case _TransitionType.product:
        return Curves.easeOutBack;

      case _TransitionType.cart:
        return Curves.easeOutBack;

      case _TransitionType.success:
        return Curves.elasticOut;

      case _TransitionType.restaurant:
        return Curves.easeOutCubic;

      case _TransitionType.auth:
        return Curves.easeOutBack;

      case _TransitionType.category:
        return Curves.easeOutBack;

      default:
        return Curves.easeOutCubic;
    }
  }

  _MotionParams _params(double t) {
    switch (type) {
      // ==========================================================
      // PRODUCT
      // ==========================================================

      case _TransitionType.product:
        return _MotionParams(
          x: Tween<double>(begin: .90, end: 0).transform(t),

          y: Tween<double>(begin: .035, end: 0).transform(t),

          scale: Tween<double>(begin: .72, end: 1).transform(t),

          rotateX: Tween<double>(begin: .035, end: 0).transform(t),

          rotateY: Tween<double>(begin: .13, end: 0).transform(t),

          rotateZ: Tween<double>(begin: .025, end: 0).transform(t),

          perspective: .0018,

          fadeStart: .02,

          blurStart: 14,

          exitScale: .91,

          exitRotation: -.018,

          exitX: -.025,

          exitY: 0,
        );

      // ==========================================================
      // RESTAURANT
      // ==========================================================

      case _TransitionType.restaurant:
        return _MotionParams(
          x: Tween<double>(begin: .95, end: 0).transform(t),

          y: Tween<double>(begin: .04, end: 0).transform(t),

          scale: Tween<double>(begin: .83, end: 1).transform(t),

          rotateX: Tween<double>(begin: .025, end: 0).transform(t),

          rotateY: Tween<double>(begin: .10, end: 0).transform(t),

          rotateZ: Tween<double>(begin: -.018, end: 0).transform(t),

          perspective: .0016,

          fadeStart: .08,

          blurStart: 10,

          exitScale: .93,

          exitRotation: -.014,

          exitX: -.025,

          exitY: 0,
        );

      // ==========================================================
      // CART
      // ==========================================================

      case _TransitionType.cart:
        return _MotionParams(
          x: 0,

          y: Tween<double>(begin: .90, end: 0).transform(t),

          scale: Tween<double>(begin: .82, end: 1).transform(t),

          rotateX: Tween<double>(begin: -.08, end: 0).transform(t),

          rotateY: 0,

          rotateZ: Tween<double>(begin: .02, end: 0).transform(t),

          perspective: .0018,

          fadeStart: .05,

          blurStart: 11,

          exitScale: .95,

          exitRotation: 0,

          exitX: 0,

          exitY: -.018,
        );

      // ==========================================================
      // CHECKOUT
      // ==========================================================

      case _TransitionType.checkout:
        return _MotionParams(
          x: Tween<double>(begin: -.90, end: 0).transform(t),

          y: 0,

          scale: Tween<double>(begin: .86, end: 1).transform(t),

          rotateX: 0,

          rotateY: Tween<double>(begin: -.075, end: 0).transform(t),

          rotateZ: Tween<double>(begin: -.015, end: 0).transform(t),

          perspective: .0016,

          fadeStart: .06,

          blurStart: 9,

          exitScale: .94,

          exitRotation: .012,

          exitX: .025,

          exitY: 0,
        );

      // ==========================================================
      // LOCATION
      // ==========================================================

      case _TransitionType.location:
        return _MotionParams(
          x: 0,

          y: Tween<double>(begin: .10, end: 0).transform(t),

          scale: Tween<double>(begin: .58, end: 1).transform(t),

          rotateX: Tween<double>(begin: .03, end: 0).transform(t),

          rotateY: Tween<double>(begin: .025, end: 0).transform(t),

          rotateZ: Tween<double>(begin: .025, end: 0).transform(t),

          perspective: .0013,

          fadeStart: 0,

          blurStart: 14,

          exitScale: .95,

          exitRotation: 0,

          exitX: 0,

          exitY: 0,
        );

      // ==========================================================
      // SUCCESS
      // ==========================================================

      case _TransitionType.success:
        return _MotionParams(
          x: 0,

          y: Tween<double>(begin: .03, end: 0).transform(t),

          scale: Tween<double>(begin: .60, end: 1).transform(t),

          rotateX: Tween<double>(begin: .03, end: 0).transform(t),

          rotateY: Tween<double>(begin: -.06, end: 0).transform(t),

          rotateZ: Tween<double>(begin: -.04, end: 0).transform(t),

          perspective: .0018,

          fadeStart: 0,

          blurStart: 15,

          exitScale: .92,

          exitRotation: -.02,

          exitX: 0,

          exitY: -.012,
        );

      // ==========================================================
      // DETAILS
      // ==========================================================

      case _TransitionType.details:
        return _MotionParams(
          x: Tween<double>(begin: .65, end: 0).transform(t),

          y: Tween<double>(begin: .015, end: 0).transform(t),

          scale: Tween<double>(begin: .87, end: 1).transform(t),

          rotateX: 0,

          rotateY: Tween<double>(begin: .065, end: 0).transform(t),

          rotateZ: 0,

          perspective: .0013,

          fadeStart: .04,

          blurStart: 7,

          exitScale: .96,

          exitRotation: 0,

          exitX: -.015,

          exitY: 0,
        );

      // ==========================================================
      // AUTH
      // ==========================================================

      case _TransitionType.auth:
        return _MotionParams(
          x: Tween<double>(begin: .78, end: 0).transform(t),

          y: Tween<double>(begin: .08, end: 0).transform(t),

          scale: Tween<double>(begin: .80, end: 1).transform(t),

          rotateX: Tween<double>(begin: .035, end: 0).transform(t),

          rotateY: Tween<double>(begin: .045, end: 0).transform(t),

          rotateZ: Tween<double>(begin: .025, end: 0).transform(t),

          perspective: .0016,

          fadeStart: 0,

          blurStart: 12,

          exitScale: .94,

          exitRotation: -.015,

          exitX: -.02,

          exitY: 0,
        );

      // ==========================================================
      // PANEL
      // ==========================================================

      case _TransitionType.panel:
        return _MotionParams(
          x: Tween<double>(begin: .46, end: 0).transform(t),

          y: Tween<double>(begin: .02, end: 0).transform(t),

          scale: Tween<double>(begin: .90, end: 1).transform(t),

          rotateX: 0,

          rotateY: Tween<double>(begin: .03, end: 0).transform(t),

          rotateZ: 0,

          perspective: .0012,

          fadeStart: .08,

          blurStart: 5,

          exitScale: .97,

          exitRotation: 0,

          exitX: -.01,

          exitY: 0,
        );

      // ==========================================================
      // CATEGORY
      // ==========================================================

      case _TransitionType.category:
        return _MotionParams(
          x: Tween<double>(begin: .58, end: 0).transform(t),

          y: Tween<double>(begin: .03, end: 0).transform(t),

          scale: Tween<double>(begin: .75, end: 1).transform(t),

          rotateX: Tween<double>(begin: .02, end: 0).transform(t),

          rotateY: Tween<double>(begin: .065, end: 0).transform(t),

          rotateZ: Tween<double>(begin: -.025, end: 0).transform(t),

          perspective: .0015,

          fadeStart: .01,

          blurStart: 10,

          exitScale: .94,

          exitRotation: -.012,

          exitX: -.02,

          exitY: 0,
        );

      // ==========================================================
      // TAB
      // ==========================================================

      case _TransitionType.tab:
        return _MotionParams(
          x: Tween<double>(begin: .24, end: 0).transform(t),

          y: Tween<double>(begin: .018, end: 0).transform(t),

          scale: Tween<double>(begin: .93, end: 1).transform(t),

          rotateX: 0,

          rotateY: Tween<double>(begin: .02, end: 0).transform(t),

          rotateZ: 0,

          perspective: .001,

          fadeStart: .10,

          blurStart: 3,

          exitScale: .98,

          exitRotation: 0,

          exitX: -.01,

          exitY: 0,
        );

      // ==========================================================
      // DEFAULT
      // ==========================================================

      case _TransitionType.cinematic:
        return _MotionParams(
          x: Tween<double>(begin: .64, end: 0).transform(t),

          y: Tween<double>(begin: .03, end: 0).transform(t),

          scale: Tween<double>(begin: .85, end: 1).transform(t),

          rotateX: Tween<double>(begin: .02, end: 0).transform(t),

          rotateY: Tween<double>(begin: .07, end: 0).transform(t),

          rotateZ: Tween<double>(begin: .012, end: 0).transform(t),

          perspective: .0014,

          fadeStart: .05,

          blurStart: 8,

          exitScale: .95,

          exitRotation: -.01,

          exitX: -.015,

          exitY: 0,
        );
    }
  }
}
// ============================================================
// MOTION PARAMETERS
// ============================================================

class _MotionParams {
  const _MotionParams({
    required this.x,
    required this.y,
    required this.scale,
    required this.rotateX,
    required this.rotateY,
    required this.rotateZ,
    required this.perspective,
    required this.fadeStart,
    required this.blurStart,
    required this.exitScale,
    required this.exitRotation,
    required this.exitX,
    required this.exitY,
  });

  final double x;
  final double y;

  final double scale;

  final double rotateX;
  final double rotateY;
  final double rotateZ;

  final double perspective;

  final double fadeStart;
  final double blurStart;

  final double exitScale;
  final double exitRotation;
  final double exitX;
  final double exitY;
}

class _FavoriteProductResolver extends StatelessWidget {
  const _FavoriteProductResolver({required this.productId});

  final String productId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BusinessProfileCubit, BusinessProfileState>(
      builder: (context, state) {
        // ==========================================================
        // LOADING
        // ==========================================================
        if (state is BusinessProfileInitial ||
            state is BusinessProfileLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // ==========================================================
        // ERROR
        // ==========================================================
        if (state is BusinessProfileFailure) {
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  state.message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          );
        }

        // ==========================================================
        // LOADED
        // ==========================================================
        if (state is BusinessProfileLoaded) {
          Product? product;

          for (final item in state.products) {
            if (item.id == productId) {
              product = item;
              break;
            }
          }

          if (product == null) {
            return const Scaffold(
              body: Center(
                child: Text(
                  'المنتج غير موجود أو تم حذفه',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
            );
          }

          return ProductDetailsPage(
            arguments: ProductDetailsArguments(
              product: product,
              business: state.business,
            ),
          );
        }

        return const Scaffold(body: SizedBox.shrink());
      },
    );
  }
}
