import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/errors/location_failure.dart';

class LocationErrorView extends StatelessWidget {
  const LocationErrorView({
    super.key,
    required this.failure,
    required this.onRetry,
  });

  final LocationFailure failure;
  final VoidCallback onRetry;

  String _text(BuildContext context, String ar, String en) {
    return Localizations.localeOf(context).languageCode == 'ar' ? ar : en;
  }

  Future<void> _openFix() async {
    if (failure.kind == LocationFailureKind.serviceDisabled) {
      await Geolocator.openLocationSettings();
    } else if (failure.kind == LocationFailureKind.permissionDeniedForever) {
      await Geolocator.openAppSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    final needsSettings =
        failure.kind == LocationFailureKind.serviceDisabled ||
        failure.kind == LocationFailureKind.permissionDeniedForever;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 76,
                  height: 76,
                  decoration: const BoxDecoration(
                    color: AppColors.surfaceLight,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    needsSettings
                        ? Icons.location_off_rounded
                        : Icons.error_outline_rounded,
                    color: AppColors.secondary,
                    size: 38,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  failure.kind == LocationFailureKind.permissionDeniedForever
                      ? _text(
                          context,
                          'صلاحية الموقع مرفوضة نهائيًا',
                          'Location permission is permanently denied',
                        )
                      : failure.kind == LocationFailureKind.serviceDisabled
                      ? _text(
                          context,
                          'خدمة الموقع مغلقة',
                          'Location services are disabled',
                        )
                      : _text(
                          context,
                          'تعذر تحديد موقعك',
                          'Unable to get your location',
                        ),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  failure.message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: needsSettings ? _openFix : onRetry,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                      needsSettings
                          ? _text(context, 'فتح الإعدادات', 'Open settings')
                          : _text(context, 'حاول مرة أخرى', 'Try again'),
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
                if (needsSettings) ...[
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: onRetry,
                    child: Text(
                      _text(context, 'إعادة المحاولة', 'Retry'),
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
