import 'package:demix/core/di/auth_di.dart';
import 'package:demix/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:demix/features/auth/presentation/views/forget_password_view.dart';
import 'package:demix/features/auth/presentation/views/login_view.dart';
import 'package:demix/features/auth/presentation/views/sign_up_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:demix/generated/l10n.dart';

import 'package:demix/core/routing/router_names.dart';
import 'package:demix/core/routing/navigation.dart';

import 'package:demix/features/splash/presentation/views/splash_view.dart';

import 'package:demix/features/home/presentation/views/home_view.dart';

class AppRouter {
  AppRouter._();

  static late final GoRouter router;

  /// Initializes the router for one application surface.
  ///
  /// The same Firebase/backend is shared between the three apps,
  /// but the exposed navigation surface is determined by [appMode].
  static void initialize() {
    router = GoRouter(
      initialLocation: RoutePaths.splash,

      errorBuilder: (context, state) {
        return DemixErrorView(error: state);
      },

      routes: [
        // ============================================================
        // SPLASH
        // ============================================================
        GoRoute(
          path: RoutePaths.splash,
          name: 'splash',
          builder: (context, state) {
            return const SplashView();
          },
        ),
        GoRoute(
          path: RoutePaths.login,
          name: 'login',
          builder: (context, state) {
            return const LoginView();
          },
        ),

        GoRoute(
          path: RoutePaths.signup,
          name: 'signup',
          builder: (context, state) {
            return SignupView();
          },
        ),
        GoRoute(
          path: RoutePaths.forgotPassword,
          name: 'forget-passowrd',
          builder: (context, state) {
            return ForgotPasswordPage();
          },
        ),
        // ============================================================
        // CUSTOMER / PUBLIC
        // ============================================================
        GoRoute(
          path: RoutePaths.home,
          name: 'home',
          builder: (context, state) {
            return const HomeView();
          },
        ),

        // ============================================================
        // INFORMATION
        // ============================================================
        GoRoute(
          path: RoutePaths.notifications,
          name: 'notifications',
          builder: (context, state) {
            return InformationView(
              title: S.of(context).notifications,
              description: S.of(context).notifications,
              icon: Icons.notifications_none_rounded,
            );
          },
        ),

        GoRoute(
          path: RoutePaths.privacy,
          name: 'privacy',
          builder: (context, state) {
            return InformationView(
              title: S.of(context).privacy,
              description: S.of(context).privacy,
              icon: Icons.shield_outlined,
            );
          },
        ),

        GoRoute(
          path: RoutePaths.terms,
          name: 'terms',
          builder: (context, state) {
            return InformationView(
              title: S.of(context).terms,
              description: S.of(context).terms,
              icon: Icons.description_outlined,
            );
          },
        ),

        GoRoute(
          path: RoutePaths.offers,
          name: 'offers',
          builder: (context, state) {
            final isArabic =
                Localizations.localeOf(context).languageCode == 'ar';

            return InformationView(
              title: isArabic ? 'العروض والكوبونات' : 'Coupons & Offers',
              description: isArabic
                  ? 'ستظهر هنا العروض والكوبونات المحفوظة.'
                  : 'Your saved offers and available coupons will appear here.',
              icon: Icons.local_offer_outlined,
            );
          },
        ),

        // ============================================================
      ],
    );
  }
}
