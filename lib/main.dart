import 'package:demix/core/di/auth_di.dart';
import 'package:demix/core/widgets/snack_bar/app_snack_bar_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:demix/firebase_options.dart';

import 'package:demix/generated/l10n.dart';
import 'package:demix/core/localization/locale_controller.dart';
import 'package:demix/core/routing/app_router.dart';

// Auth
import 'package:demix/features/auth/presentation/cubit/auth_cubit.dart';

// DI

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ------------------------------------------------------------
  // Firebase
  // ------------------------------------------------------------

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // ------------------------------------------------------------
  // Dependency Injection
  // ------------------------------------------------------------

  setupAuthDependencies();

  // ------------------------------------------------------------
  // App
  // ------------------------------------------------------------

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
            theme: _buildTheme(),

            scaffoldMessengerKey: AppSnackBarService.instance.messengerKey,

            locale: LocaleController.instance.locale,

            supportedLocales: S.delegate.supportedLocales,

            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],

            routerConfig: AppRouter.router,

            debugShowCheckedModeBanner: false,

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
