import 'package:demix/core/db/shared_preferance.dart';
import 'package:demix/core/di/auth_di.dart';
import 'package:demix/core/di/business_di.dart';
import 'package:demix/core/di/location_di.dart';
import 'package:demix/core/widgets/snack_bar/app_snack_bar_service.dart';

import 'package:demix/features/auth/presentation/cubit/auth_cubit.dart';

// Location

import 'package:demix/firebase_options.dart';
import 'package:demix/generated/l10n.dart';

import 'package:demix/core/localization/locale_controller.dart';
import 'package:demix/core/routing/app_router.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ---------------------------------------------------------------------------
  // Shared Preferences
  // ---------------------------------------------------------------------------

  await SharedPreference.init();

  // ---------------------------------------------------------------------------
  // Firebase
  // ---------------------------------------------------------------------------

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // ---------------------------------------------------------------------------
  // Dependency Injection
  // ---------------------------------------------------------------------------

  setupAuthDependencies(getIt);
  setupBusinessDependencies(getIt);
  setupLocationDependencies(
    getIt,
    userAgent: 'DeMiX/1.0 (mahmoud.said.developer@gmail.com)',
    languageCode: 'ar',
  );

  // ---------------------------------------------------------------------------
  // Run App
  // ---------------------------------------------------------------------------

  runApp(const DemixApp());
}

class DemixApp extends StatelessWidget {
  const DemixApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const _DemixMaterialApp();
  }
}

class _DemixMaterialApp extends StatefulWidget {
  const _DemixMaterialApp();

  @override
  State<_DemixMaterialApp> createState() => _DemixMaterialAppState();
}

class _DemixMaterialAppState extends State<_DemixMaterialApp> {
  @override
  void initState() {
    super.initState();

    // -------------------------------------------------------------------------
    // Router
    // -------------------------------------------------------------------------

    AppRouter.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>(
      create: (_) => getIt<AuthCubit>()..initialize(),
      child: AnimatedBuilder(
        animation: LocaleController.instance,
        builder: (context, child) {
          return MaterialApp.router(
            // -----------------------------------------------------------------
            // Theme
            // -----------------------------------------------------------------
            theme: _buildTheme(),

            // -----------------------------------------------------------------
            // SnackBar
            // -----------------------------------------------------------------
            scaffoldMessengerKey: AppSnackBarService.instance.messengerKey,

            // -----------------------------------------------------------------
            // Localization
            // -----------------------------------------------------------------
            locale: LocaleController.instance.locale,

            supportedLocales: S.delegate.supportedLocales,

            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],

            // -----------------------------------------------------------------
            // Router
            // -----------------------------------------------------------------
            routerConfig: AppRouter.router,

            // -----------------------------------------------------------------
            // Debug
            // -----------------------------------------------------------------
            debugShowCheckedModeBanner: false,

            // -----------------------------------------------------------------
            // Global Builder
            // -----------------------------------------------------------------
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(
                  context,
                ).copyWith(textScaler: const TextScaler.linear(1.0)),
                child: child ?? const SizedBox.shrink(),
              );
            },
          );
        },
      ),
    );
  }

  ThemeData _buildTheme() {
    return ThemeData(
      fontFamily: 'cairo',
      scaffoldBackgroundColor: Colors.white,
      brightness: Brightness.light,
      useMaterial3: true,
    );
  }
}
