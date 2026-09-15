import 'dart:async';

import 'package:demix/features/location/domain/entities/service_zone.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/location_coordinate.dart';
import '../../domain/entities/location_entity.dart';
import '../../domain/use_cases/check_service_zone_use_case.dart';
import '../../domain/use_cases/get_current_device_location_use_case.dart';
import '../../domain/use_cases/reverse_geocode_use_case.dart';
import '../../domain/use_cases/save_current_location_use_case.dart';
import 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  LocationCubit({
    required this._getCurrentLocation,
    required this._reverseGeocode,
    required this._checkServiceZone,
    required this._saveCurrentLocation,
  }) : super(const LocationInitial());

  final GetCurrentDeviceLocationUseCase _getCurrentLocation;
  final ReverseGeocodeUseCase _reverseGeocode;
  final CheckServiceZoneUseCase _checkServiceZone;
  final SaveCurrentLocationUseCase _saveCurrentLocation;

  Timer? _debounce;
  int _generation = 0;

  Future<void> initialize() async {
    _debounce?.cancel();
    _generation++;
    emit(const LocationLoading());

    final result = await _getCurrentLocation();

    await result.fold(
      (failure) async {
        if (!isClosed) emit(LocationFailureState(failure));
      },
      (coordinate) async {
        if (isClosed) return;

        emit(
          LocationReady(
            deviceLocation: coordinate,
            selectedLocation: coordinate,
            addressLoading: true,
            zoneChecking: true,
            insideZone: false,
          ),
        );

        final generation = _generation;
        await _resolveSelection(coordinate, generation);
      },
    );
  }

  void onMapMoved(LocationCoordinate coordinate) {
    final current = state;
    if (current is! LocationReady || isClosed) return;

    _generation++;
    final generation = _generation;
    _debounce?.cancel();

    emit(
      current.copyWith(
        selectedLocation: coordinate,
        addressLoading: true,
        zoneChecking: true,
        insideZone: false,
        clearZone: true,
        clearAddress: true,
        clearNotice: true,
        saving: false,
      ),
    );

    _debounce = Timer(const Duration(milliseconds: 900), () async {
      if (generation != _generation || isClosed) return;
      await _resolveSelection(coordinate, generation);
    });
  }

  Future<void> selectCurrentLocation() async {
    final result = await _getCurrentLocation();

    await result.fold(
      (failure) async {
        final current = state;
        if (!isClosed && current is LocationReady) {
          emit(
            current.copyWith(
              notice: failure.message,
              clearNotice: false,
              saving: false,
            ),
          );
        } else if (!isClosed) {
          emit(LocationFailureState(failure));
        }
      },
      (coordinate) async {
        if (isClosed) return;

        _generation++;
        _debounce?.cancel();

        final current = state;
        final ready = current is LocationReady
            ? current.copyWith(
                deviceLocation: coordinate,
                selectedLocation: coordinate,
                addressLoading: true,
                zoneChecking: true,
                insideZone: false,
                clearZone: true,
                clearAddress: true,
                clearNotice: true,
                saving: false,
              )
            : LocationReady(
                deviceLocation: coordinate,
                selectedLocation: coordinate,
                addressLoading: true,
                zoneChecking: true,
                insideZone: false,
              );

        emit(ready);
        await _resolveSelection(coordinate, _generation);
      },
    );
  }

  Future<void> _resolveSelection(
    LocationCoordinate coordinate,
    int generation,
  ) async {
    final addressFuture = _reverseGeocode(coordinate);
    final zoneFuture = _checkServiceZone(coordinate);

    final addressResult = await addressFuture;
    if (_isStale(generation)) return;

    final current = state;
    if (current is! LocationReady) return;

    final address = addressResult.fold<LocationEntity?>(
      (_) => null,
      (value) => value,
    );
    final addressNotice = addressResult.fold<String?>(
      (failure) => failure.message,
      (_) => null,
    );

    emit(
      current.copyWith(
        address: address,
        clearAddress: address == null,
        addressLoading: false,
        zoneChecking: true,
        notice: addressNotice,
        clearNotice: addressNotice == null,
        saving: false,
      ),
    );

    final zoneResult = await zoneFuture;
    if (_isStale(generation)) return;

    final latest = state;
    if (latest is! LocationReady) return;

    final match = zoneResult.fold<ServiceZoneMatch?>(
      (_) => null,
      (value) => value,
    );

    final inside = match?.isInside ?? false;
    final zoneNotice = zoneResult.fold<String?>(
      (failure) => failure.message,
      (value) => value.isInside ? null : _outOfAreaMessage(),
    );

    emit(
      latest.copyWith(
        insideZone: inside,
        zoneChecking: false,
        zone: match?.zone,
        clearZone: match?.zone == null,
        notice: zoneNotice ?? addressNotice,
        clearNotice: zoneNotice == null && addressNotice == null,
        saving: false,
      ),
    );
  }

  Future<void> confirm() async {
    final current = state;
    if (current is! LocationReady || !current.canConfirm) return;

    emit(current.copyWith(saving: true, clearNotice: true));

    final address = current.address!;
    final location = LocationEntity(
      id: 1,
      latitude: current.selectedLocation.latitude,
      longitude: current.selectedLocation.longitude,
      country: address.country,
      city: address.city,
      area: address.area,
      street: address.street,
      formattedAddress: address.formattedAddress,
      zoneId: current.zone?.id,
      isInsideZone: true,
      createdAt: address.createdAt,
      updatedAt: DateTime.now(),
    );

    final result = await _saveCurrentLocation(location);
    if (isClosed) return;

    result.fold((failure) {
      emit(
        current.copyWith(
          saving: false,
          notice: failure.message,
          clearNotice: false,
        ),
      );
    }, (saved) => emit(LocationSaved(saved)));
  }

  void retry() => initialize();

  bool _isStale(int generation) => isClosed || generation != _generation;

  String _outOfAreaMessage() => 'Out of delivery area.';

  @override
  Future<void> close() async {
    _debounce?.cancel();
    return super.close();
  }
}
