import 'package:demix/core/routing/route_paths.dart';
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

import 'package:demix/core/di/location_di.dart';

import 'package:demix/features/business/presentation/pages/category_view.dart';
import 'package:demix/features/business/presentation/pages/business_profile_page.dart';
import 'package:demix/features/favorite/presentation/view/favorite_view.dart';

import 'package:demix/features/location/presentation/cubit/location_cubit.dart';
import 'package:demix/features/location/presentation/pages/location_page.dart';

import 'package:demix/features/onboarding/presentation/onboarding_view.dart';

import 'package:demix/features/product_ordering/presentation/pages/product_details_page.dart';

import 'package:demix/features/cart/presentation/pages/cart_page.dart';

import 'package:demix/features/checkout/presentation/pages/checkout_page.dart';
import 'package:demix/features/checkout/presentation/pages/checkout_location_picker_page.dart';

import 'package:demix/features/orders/presentation/pages/order_success_page.dart';
import 'package:demix/features/orders/presentation/pages/order_details_page.dart';

import 'package:demix/main.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:demix/generated/l10n.dart';

import 'package:demix/core/routing/navigation.dart';

import 'package:demix/features/splash/presentation/views/splash_view.dart';
import 'package:demix/features/home/presentation/views/home_view.dart';

class AppRouter {
  AppRouter._();

  static late final GoRouter router;

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
          path: RoutePaths.favorites,
          builder: (context, state) {
            return const FavoritesView();
          },
        ),
        GoRoute(
          path: RoutePaths.profile,
          builder: (context, state) {
            return const ProfileView();
          },
        ),

        GoRoute(
          path: RoutePaths.editProfile,
          builder: (context, state) {
            return const EditProfileView();
          },
        ),

        GoRoute(
          path: RoutePaths.settings,
          builder: (context, state) {
            return const SettingsView();
          },
        ),

        GoRoute(
          path: RoutePaths.language,
          builder: (context, state) {
            return const LanguageView();
          },
        ),

        GoRoute(
          path: RoutePaths.notifications,
          builder: (context, state) {
            return const NotificationsView();
          },
        ),

        GoRoute(
          path: RoutePaths.privacy,
          builder: (context, state) {
            return const PrivacyView();
          },
        ),

        GoRoute(
          path: RoutePaths.terms,
          builder: (context, state) {
            return const TermsView();
          },
        ),

        GoRoute(
          path: RoutePaths.support,
          builder: (context, state) {
            return const SupportView();
          },
        ),

        GoRoute(
          path: RoutePaths.about,
          builder: (context, state) {
            return const AboutView();
          },
        ),

        // ============================================================
        // BUSINESS CATEGORY
        // Restaurants / Cafes
        // ============================================================
        GoRoute(
          path: RoutePaths.category,
          name: 'category',
          builder: (context, state) {
            final type = state.pathParameters['categoryId'] ?? 'restaurant';

            return CategoryView(type: type);
          },
        ),

        // ============================================================
        // RESTAURANT / CAFE DETAILS
        // ============================================================
        GoRoute(
          path: RoutePaths.restaurant,
          name: 'restaurant',
          builder: (context, state) {
            final restaurantId = state.pathParameters['restaurantId']!;

            return BusinessProfilePage(businessId: restaurantId);
          },
        ),

        // ============================================================
        // PRODUCT DETAILS
        // ============================================================
        GoRoute(
          path: RoutePaths.product,
          name: 'product',
          builder: (context, state) {
            final arguments = state.extra as ProductDetailsArguments;

            return ProductDetailsPage(arguments: arguments);
          },
        ),

        // ============================================================
        // CART
        // ============================================================
        GoRoute(
          path: RoutePaths.cart,
          name: 'cart',
          builder: (context, state) {
            return const CartPage();
          },
        ),

        // ============================================================
        // CHECKOUT
        // ============================================================
        GoRoute(
          path: RoutePaths.checkout,
          name: 'checkout',
          builder: (context, state) {
            final arguments = state.extra as CheckoutArguments;

            return CheckoutPage(arguments: arguments);
          },
        ),

        // ============================================================
        // CHECKOUT LOCATION
        // Uses the existing Location Feature
        // ============================================================
        GoRoute(
          path: RoutePaths.checkoutLocation,
          name: 'checkout-location',
          builder: (context, state) {
            return const CheckoutLocationPickerPage();
          },
        ),

        // ============================================================
        // LOCATION
        // ============================================================
        GoRoute(
          path: RoutePaths.location,
          name: 'location',
          builder: (context, state) {
            return BlocProvider(
              create: (_) => getIt<LocationCubit>()..initialize(),
              child: LocationPage(
                onConfirmed: () async {
                  if (!context.mounted) return;

                  context.go(RoutePaths.home);
                },
              ),
            );
          },
        ),

        // ============================================================
        // ONBOARDING
        // ============================================================
        GoRoute(
          path: RoutePaths.onboarding,
          name: 'onBoarding',
          builder: (context, state) {
            return const OnboardingView();
          },
        ),

        // ============================================================
        // AUTH
        // ============================================================
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
        // HOME
        // ============================================================
        GoRoute(
          path: RoutePaths.home,
          name: 'home',
          builder: (context, state) {
            return const HomeView();
          },
        ),

        // ============================================================
        // ORDER SUCCESS
        // ============================================================
        GoRoute(
          path: RoutePaths.orderSuccess,
          name: 'order-success',
          builder: (context, state) {
            final orderId = state.pathParameters['orderId']!;

            final orderNumber = state.uri.queryParameters['orderNumber'] ?? '';

            return OrderSuccessPage(orderId: orderId, orderNumber: orderNumber);
          },
        ),

        // ============================================================
        // ORDER DETAILS / TRACKING
        // ============================================================
        GoRoute(
          path: RoutePaths.orderDetailsById,
          name: 'order-details',
          builder: (context, state) {
            final orderId = state.pathParameters['orderId']!;

            return OrderDetailsPage(orderId: orderId);
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
      ],
    );
  }
}
