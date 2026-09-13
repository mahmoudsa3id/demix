import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/datasources/zone/kafr_el_dawar_zones.dart';
import '../../domain/entities/location_coordinate.dart';
import '../cubit/location_cubit.dart';
import '../cubit/location_state.dart';
import '../widgets/location_error_view.dart';
import '../widgets/location_map.dart';
import '../widgets/location_status_card.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({
    super.key,
    required this.onConfirmed,
  });

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
      15,
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
          return const Scaffold(
            backgroundColor: AppColors.background,
            body: Center(
              child: CircularProgressIndicator(
                color: AppColors.secondary,
              ),
            ),
          );
        }

        if (state is LocationFailureState) {
          return LocationErrorView(
            failure: state.failure,
            onRetry: context.read<LocationCubit>().retry,
          );
        }

        if (state is! LocationReady) {
          return const SizedBox.shrink();
        }

        final cubit = context.read<LocationCubit>();

        return Scaffold(
          backgroundColor: AppColors.background,
          body: Stack(
            children: [
              Positioned.fill(
                child: LocationMap(
                  mapController: _mapController,
                  initialCenter: state.selectedLocation,
                  onCameraChanged: cubit.onMapMoved,
                  deviceLocation: state.deviceLocation,
                  zone: state.zone,
                ),
              ),

              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: Row(
                    children: [
                      _circleButton(
                        icon: Icons.arrow_back_rounded,
                        onTap: () => Navigator.of(context).maybePop(),
                      ),
                      const Spacer(),
                      _circleButton(
                        icon: Icons.my_location_rounded,
                        onTap: () async {
                          await cubit.selectCurrentLocation();
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

              Positioned(
                top: MediaQuery.of(context).padding.top + 72,
                left: 16,
                right: 16,
                child: _selectionHint(),
              ),

              Align(
                alignment: Alignment.bottomCenter,
                child: LocationStatusCard(
                  location: state.address,
                  addressLoading: state.addressLoading,
                  zoneChecking: state.zoneChecking,
                  insideZone: state.insideZone,
                  saving: state.saving,
                  notice: state.notice,
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
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          decoration: BoxDecoration(
            color: AppColors.surface.withOpacity(.92),
            borderRadius: BorderRadius.circular(999),
            boxShadow: const [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Text(
            _text(
              'حرّك الخريطة وضع الدبوس على المكان المطلوب',
              'Move the map and place the pin on the desired location',
            ),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  Widget _circleButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(50),
        child: Ink(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.surface.withOpacity(.94),
            shape: BoxShape.circle,
            boxShadow: const [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Icon(icon, color: AppColors.textPrimary),
        ),
      ),
    );
  }
}
