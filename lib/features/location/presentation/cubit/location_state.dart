import '../../core/errors/location_failure.dart';
import '../../domain/entities/location_coordinate.dart';
import '../../domain/entities/location_entity.dart';
import '../../domain/entities/service_zone.dart';

sealed class LocationState {
  const LocationState();
}

class LocationInitial extends LocationState {
  const LocationInitial();
}

class LocationLoading extends LocationState {
  const LocationLoading();
}

class LocationReady extends LocationState {
  const LocationReady({
    required this.deviceLocation,
    required this.selectedLocation,
    required this.addressLoading,
    required this.zoneChecking,
    required this.insideZone,
    this.zone,
    this.address,
    this.notice,
    this.saving = false,
  });

  final LocationCoordinate deviceLocation;
  final LocationCoordinate selectedLocation;
  final bool addressLoading;
  final bool zoneChecking;
  final bool insideZone;
  final ServiceZone? zone;
  final LocationEntity? address;
  final String? notice;
  final bool saving;

  bool get canConfirm =>
      insideZone &&
      !addressLoading &&
      !zoneChecking &&
      !saving &&
      address != null;

  LocationReady copyWith({
    LocationCoordinate? deviceLocation,
    LocationCoordinate? selectedLocation,
    bool? addressLoading,
    bool? zoneChecking,
    bool? insideZone,
    ServiceZone? zone,
    bool clearZone = false,
    LocationEntity? address,
    bool clearAddress = false,
    String? notice,
    bool clearNotice = false,
    bool? saving,
  }) {
    return LocationReady(
      deviceLocation: deviceLocation ?? this.deviceLocation,
      selectedLocation: selectedLocation ?? this.selectedLocation,
      addressLoading: addressLoading ?? this.addressLoading,
      zoneChecking: zoneChecking ?? this.zoneChecking,
      insideZone: insideZone ?? this.insideZone,
      zone: clearZone ? null : (zone ?? this.zone),
      address: clearAddress ? null : (address ?? this.address),
      notice: clearNotice ? null : (notice ?? this.notice),
      saving: saving ?? this.saving,
    );
  }
}

class LocationFailureState extends LocationState {
  const LocationFailureState(this.failure);
  final LocationFailure failure;
}

class LocationSaved extends LocationState {
  const LocationSaved(this.location);
  final LocationEntity location;
}
