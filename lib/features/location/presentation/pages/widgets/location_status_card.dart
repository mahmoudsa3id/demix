import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../domain/entities/location_entity.dart';

class LocationStatusCard extends StatelessWidget {
  const LocationStatusCard({
    super.key,
    required this.location,
    required this.addressLoading,
    required this.zoneChecking,
    required this.insideZone,
    required this.saving,
    required this.notice,
    required this.onConfirm,
  });

  final LocationEntity? location;
  final bool addressLoading;
  final bool zoneChecking;
  final bool insideZone;
  final bool saving;
  final String? notice;
  final VoidCallback onConfirm;

  String _text(BuildContext context, String ar, String en) {
    return Localizations.localeOf(context).languageCode == 'ar' ? ar : en;
  }

  @override
  Widget build(BuildContext context) {
    final loading = addressLoading || zoneChecking;
    final address = location?.formattedAddress;
    final canConfirm = insideZone && !loading && !saving && location != null;

    final title = loading
        ? _text(context, 'جاري تحديد الموقع...', 'Checking location...')
        : insideZone
        ? _text(context, 'التوصيل متاح', 'Delivery available')
        : _text(context, 'خارج نطاق التوصيل', 'Out of delivery area');

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowDark,
            blurRadius: 24,
            offset: Offset(0, -6),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: const BoxDecoration(
                  color: AppColors.textMuted,
                  borderRadius: BorderRadius.all(Radius.circular(99)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  loading
                      ? Icons.location_searching_rounded
                      : insideZone
                      ? Icons.check_circle_rounded
                      : Icons.location_off_rounded,
                  color: loading
                      ? AppColors.warning
                      : insideZone
                      ? AppColors.success
                      : AppColors.error,
                  size: 26,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: AppTextStyles.deliverySubtitle.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (address != null && address.isNotEmpty)
              Text(
                address,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  height: 1.5,
                ),
              )
            else if (loading)
              Text(
                _text(
                  context,
                  'حرّك الخريطة لاختيار المكان المطلوب.',
                  'Move the map to choose your delivery location.',
                ),
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            if (notice != null && notice!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                notice!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: insideZone ? AppColors.textSecondary : AppColors.error,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
            ],
            const SizedBox(height: 14),
            SizedBox(
              height: 54,
              child: ElevatedButton(
                onPressed: canConfirm ? onConfirm : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: AppColors.disabledBackground,
                  disabledForegroundColor: AppColors.textMuted,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: saving
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        _text(context, 'تأكيد الموقع', 'Confirm location'),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
