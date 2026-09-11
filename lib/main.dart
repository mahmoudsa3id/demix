import 'package:demix/core/widgets/snack_bar/app_snack_bar_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:demix/generated/l10n.dart';

import 'package:demix/core/localization/locale_controller.dart';
import 'package:demix/core/routing/app_router.dart';

/// Main application entry point.
///
/// The actual application surface is selected by [appMode].
///
/// Firebase, Supabase, repositories and shared infrastructure are initialized
/// only once here. Customer / Business / Admin are separated at the routing
/// and application-surface level.
void main() {
  runApp(DemixApp());
}

/// Resolves the application mode from build-time environment.
///
/// Example:
///
/// flutter run --dart-define=DEMIX_APP=customer
/// flutter run --dart-define=DEMIX_APP=business
/// flutter run --dart-define=DEMIX_APP=admin
/// Root application widget.
///
/// The backend remains shared, while the application surface is
/// controlled by [appMode].
class DemixApp extends StatelessWidget {
  const DemixApp({super.key});

  @override
  Widget build(BuildContext context) {
    return _DemixMaterialApp();
  }
}

/// Separate widget so [restoreSession] is triggered exactly once
/// when the application root is built.
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
    return AnimatedBuilder(
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
