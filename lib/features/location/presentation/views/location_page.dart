import 'package:demix/core/routing/route_paths.dart';
import 'package:demix/features/location/presentation/views/widgets/location_loading_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/location_coordinate.dart';
import '../cubit/location_cubit.dart';
import '../cubit/location_state.dart';
import 'widgets/location_error_view.dart';
import 'widgets/location_map.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({super.key, required this.onConfirmed});

  final Future<void> Function() onConfirmed;

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  final MapController _mapController = MapController();

  String _text(String ar, String en) {
    return Localizations.localeOf(context).languageCode == 'ar' ? ar : en;
  }

  void _moveTo(LocationCoordinate coordinate) {
    if (!mounted) return;

    _mapController.move(
      LatLng(coordinate.latitude, coordinate.longitude),
      15.5,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LocationCubit, LocationState>(
      listener: (context, state) async {
        if (state is LocationSaved) {
          await widget.onConfirmed();
        }
      },
      builder: (context, state) {
        if (state is LocationInitial || state is LocationLoading) {
          return const LocationLoadingView();
        }

        if (state is LocationFailureState) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: LocationErrorView(
              failure: state.failure,
              onRetry: context.read<LocationCubit>().retry,
            ),
          );
        }

        if (state is! LocationReady) {
          return const Scaffold(backgroundColor: Colors.white);
        }

        final cubit = context.read<LocationCubit>();

        return Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            fit: StackFit.expand,
            children: [
              // ============================================================
              // FULL SCREEN MAP
              // ============================================================
              Positioned.fill(
                child: LocationMap(
                  mapController: _mapController,
                  initialCenter: state.selectedLocation,
                  onCameraChanged: cubit.onMapMoved,
                  deviceLocation: state.deviceLocation,
                  zone: state.zone,
                ),
              ),

              // ============================================================
              // TOP BAR
              // ============================================================
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    child: Row(
                      children: [
                        _circleButton(
                          icon: Icons.arrow_back_rounded,
                          onTap: () {
                            context.go(RoutePaths.home);
                          },
                        ),
                        const Spacer(),
                        _circleButton(
                          icon: Icons.my_location_rounded,
                          onTap: () async {
                            await cubit.selectCurrentLocation();

                            if (!mounted) return;

                            final current = cubit.state;

                            if (current is LocationReady) {
                              _moveTo(current.selectedLocation);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ============================================================
              // TOP HINT
              // ============================================================
              Positioned(
                top: MediaQuery.of(context).padding.top + 72,
                left: 16,
                right: 16,
                child: _selectionHint(),
              ),

              // ============================================================
              // CENTER PIN
              // ============================================================
              //
              // This stays visually over the center of the map.
              //
              Positioned.fill(
                child: IgnorePointer(
                  child: Center(
                    child: Icon(
                      Icons.location_on_rounded,
                      size: 54,
                      color: AppColors.primary,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(.25),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ============================================================
              // BOTTOM SHEET
              // ============================================================
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: _LocationBottomSheet(
                  state: state,
                  onConfirm: cubit.confirm,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _selectionHint() {
    return IgnorePointer(
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 340),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: AppColors.primary.withOpacity(.10)),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(.08),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.pan_tool_alt_rounded,
                  size: 16,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 9),
              Flexible(
                child: Text(
                  _text(
                    'حرّك الخريطة وحدد مكان التوصيل',
                    'Move the map and choose your delivery location',
                  ),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    height: 1.25,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _circleButton({required IconData icon, required VoidCallback onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(50),
        child: Ink(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primary.withOpacity(.10)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.12),
                blurRadius: 16,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Icon(icon, color: AppColors.primary, size: 22),
        ),
      ),
    );
  }
}

// ============================================================================
// BOTTOM SHEET
// ============================================================================

class _LocationBottomSheet extends StatelessWidget {
  const _LocationBottomSheet({required this.state, required this.onConfirm});

  final LocationReady state;
  final VoidCallback onConfirm;

  String _text(BuildContext context, String ar, String en) {
    return Localizations.localeOf(context).languageCode == 'ar' ? ar : en;
  }

  @override
  Widget build(BuildContext context) {
    final loading = state.addressLoading || state.zoneChecking;

    final hasAddress =
        state.address != null &&
        state.address!.formattedAddress != null &&
        state.address!.formattedAddress!.trim().isNotEmpty;

    final statusColor = loading
        ? AppColors.warning
        : state.insideZone
        ? AppColors.success
        : AppColors.error;

    final statusIcon = loading
        ? Icons.location_searching_rounded
        : state.insideZone
        ? Icons.check_circle_rounded
        : Icons.location_off_rounded;

    final statusTitle = loading
        ? _text(context, 'جاري تحديد الموقع', 'Checking location')
        : state.insideZone
        ? _text(context, 'التوصيل متاح', 'Delivery available')
        : _text(context, 'خارج نطاق التوصيل', 'Out of delivery area');

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Color(0x24000000),
            blurRadius: 24,
            offset: Offset(0, -8),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // --------------------------------------------------------------
              // HANDLE
              // --------------------------------------------------------------
              Container(
                width: 48,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFD8D5DA),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),

              const SizedBox(height: 18),

              // --------------------------------------------------------------
              // STATUS
              // --------------------------------------------------------------
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(.10),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(statusIcon, color: statusColor, size: 23),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          statusTitle,
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 19,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          loading
                              ? _text(
                                  context,
                                  'نحدد أقرب شارع وعنوان للموقع المحدد.',
                                  'Finding the nearest street and address.',
                                )
                              : state.insideZone
                              ? _text(
                                  context,
                                  'هذا العنوان متاح للتوصيل.',
                                  'This address is available for delivery.',
                                )
                              : _text(
                                  context,
                                  'اختر موقعًا داخل منطقة التوصيل.',
                                  'Choose a location inside the delivery area.',
                                ),
                          style: const TextStyle(
                            color: Color(0xFF77737A),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              // --------------------------------------------------------------
              // ADDRESS
              // --------------------------------------------------------------
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F7FA),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFEDEAF0)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(.10),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.location_on_rounded,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 11),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _text(
                              context,
                              'العنوان المحدد',
                              'Selected address',
                            ),
                            style: const TextStyle(
                              color: Color(0xFF8A858E),
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          if (loading)
                            Row(
                              children: [
                                const SizedBox(
                                  width: 15,
                                  height: 15,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 1.8,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _text(
                                      context,
                                      'جاري جلب العنوان...',
                                      'Getting address...',
                                    ),
                                    style: const TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          else if (hasAddress)
                            Text(
                              state.address!.formattedAddress!,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: AppColors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                height: 1.35,
                              ),
                            )
                          else
                            Text(
                              _text(
                                context,
                                'لم يتم العثور على شارع واضح. حرّك الخريطة.',
                                'No clear street was found. Move the map.',
                              ),
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                height: 1.4,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              if (state.notice != null && state.notice!.trim().isNotEmpty) ...[
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: state.insideZone
                        ? AppColors.primary.withOpacity(.06)
                        : AppColors.error.withOpacity(.07),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        state.insideZone
                            ? Icons.info_outline_rounded
                            : Icons.warning_amber_rounded,
                        color: state.insideZone
                            ? AppColors.primary
                            : AppColors.error,
                        size: 17,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          state.notice!,
                          style: TextStyle(
                            color: state.insideZone
                                ? AppColors.primary
                                : AppColors.error,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            height: 1.35,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 14),

              // --------------------------------------------------------------
              // CONFIRM
              // --------------------------------------------------------------
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: state.canConfirm ? onConfirm : null,
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: const Color(0xFFE9E7EC),
                    disabledForegroundColor: const Color(0xFF98939C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(17),
                    ),
                  ),
                  child: state.saving
                      ? const SizedBox(
                          width: 23,
                          height: 23,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.3,
                            color: Colors.white,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.check_rounded, size: 21),
                            const SizedBox(width: 8),
                            Text(
                              _text(
                                context,
                                'تأكيد الموقع',
                                'Confirm location',
                              ),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                ),
              ),

              const SizedBox(height: 5),

              Text(
                _text(
                  context,
                  'يمكنك تغيير العنوان لاحقًا من الصفحة الرئيسية',
                  'You can change the location later from Home',
                ),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF98939C),
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
