import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import '../../core/errors/location_failure.dart';
import '../../domain/entities/location_coordinate.dart';
import '../../domain/entities/location_entity.dart';
import '../../domain/entities/service_zone.dart';
import '../../domain/repositories/location_repository.dart';
import '../datasources/device/location_device_data_source.dart';
import '../datasources/geocoding/nominatim_geocoding_data_source.dart';
import '../datasources/local/location_local_data_source.dart';
import '../datasources/remote/location_firestore_data_source.dart';
import '../datasources/zone/service_zone_checker.dart';
import '../models/location_model.dart';

class LocationRepositoryImpl implements LocationRepository {
  LocationRepositoryImpl({
    required LocationDeviceDataSource device,
    required NominatimGeocodingDataSource geocoding,
    required LocationLocalDataSource local,
    required LocationFirestoreDataSource remote,
    required ServiceZoneChecker zoneChecker,
  }) : _device = device,
       _geocoding = geocoding,
       _local = local,
       _remote = remote,
       _zoneChecker = zoneChecker;

  final LocationDeviceDataSource _device;
  final NominatimGeocodingDataSource _geocoding;
  final LocationLocalDataSource _local;
  final LocationFirestoreDataSource _remote;
  final ServiceZoneChecker _zoneChecker;

  @override
  Future<Either<LocationFailure, LocationCoordinate>>
  getCurrentDeviceLocation() async {
    try {
      final position = await _device.getCurrentPosition();
      return Right(
        LocationCoordinate(
          latitude: position.latitude,
          longitude: position.longitude,
        ),
      );
    } on LocationServiceDisabledException catch (e) {
      return Left(
        _failure(
          LocationFailureKind.serviceDisabled,
          'Location services are disabled.',
          e,
        ),
      );
    } on PermissionDeniedForeverException catch (e) {
      return Left(
        _failure(
          LocationFailureKind.permissionDeniedForever,
          'Location permission is permanently denied.',
          e,
        ),
      );
    } on PermissionDeniedException catch (e) {
      return Left(
        _failure(
          LocationFailureKind.permissionDenied,
          'Location permission was denied.',
          e,
        ),
      );
    } on LocationGpsException catch (e) {
      return Left(
        _failure(
          LocationFailureKind.gps,
          'Unable to read the GPS location.',
          e,
        ),
      );
    } catch (e) {
      return Left(
        _failure(
          LocationFailureKind.unknown,
          'Unable to get your current location.',
          e,
        ),
      );
    }
  }

  @override
  Future<Either<LocationFailure, LocationEntity>> reverseGeocode(
    LocationCoordinate coordinate,
  ) async {
    try {
      final location = await _geocoding.reverse(coordinate);

      return Right(location);
    } on NoStreetAddressException catch (e) {
      return Left(
        _failure(
          LocationFailureKind.geocoding,
          'لم يتم العثور على شارع واضح في هذا المكان.',
          e,
        ),
      );
    } on TimeoutException catch (e) {
      return Left(
        _failure(
          LocationFailureKind.network,
          'Reverse geocoding timed out.',
          e,
        ),
      );
    } on NominatimException catch (e) {
      return Left(
        _failure(
          LocationFailureKind.geocoding,
          'Unable to determine the address.',
          e,
        ),
      );
    } catch (e) {
      return Left(
        _failure(
          LocationFailureKind.geocoding,
          'Unable to determine the address.',
          e,
        ),
      );
    }
  }

  @override
  Future<Either<LocationFailure, ServiceZoneMatch>> checkServiceZone(
    LocationCoordinate coordinate,
  ) async {
    try {
      return Right(await _zoneChecker.check(coordinate));
    } catch (e) {
      return Left(
        _failure(
          LocationFailureKind.validation,
          'Unable to check service availability.',
          e,
        ),
      );
    }
  }

  @override
  Future<Either<LocationFailure, LocationEntity>> saveCurrentLocation(
    LocationEntity location,
  ) async {
    if (!location.isInsideZone) {
      return const Left(
        LocationFailure(
          kind: LocationFailureKind.validation,
          message: 'Only locations inside the service zone can be saved.',
        ),
      );
    }

    final now = DateTime.now();
    final model = LocationModel.fromEntity(
      location.copyWith(
        id: 1,
        createdAt: location.createdAt ?? now,
        updatedAt: now,
      ),
    );

    try {
      await _local.create(model);
    } catch (e) {
      return Left(
        _failure(
          LocationFailureKind.database,
          'Unable to save your location locally.',
          e,
        ),
      );
    }

    try {
      await _remote.createOrReplace(model);
      return Right(model);
    } on LocationUnauthenticatedException catch (e) {
      await _safeDeleteLocal();
      return Left(
        _failure(
          LocationFailureKind.unauthenticated,
          'You must be signed in to save a location.',
          e,
        ),
      );
    } on FirebaseException catch (e) {
      await _safeDeleteLocal();
      return Left(_mapFirebaseFailure(e));
    } catch (e) {
      await _safeDeleteLocal();
      return Left(
        _failure(
          LocationFailureKind.network,
          'Unable to save your location remotely.',
          e,
        ),
      );
    }
  }

  @override
  Future<Either<LocationFailure, LocationEntity?>> getSavedLocation() async {
    try {
      return Right(await _local.readCurrent());
    } catch (e) {
      return Left(
        _failure(
          LocationFailureKind.database,
          'Unable to read your saved location.',
          e,
        ),
      );
    }
  }

  @override
  Future<Either<LocationFailure, Unit>> updateCurrentLocation(
    LocationEntity location,
  ) async {
    if (!location.isInsideZone) {
      return const Left(
        LocationFailure(
          kind: LocationFailureKind.validation,
          message: 'Only locations inside the service zone can be saved.',
        ),
      );
    }

    final model = LocationModel.fromEntity(
      location.copyWith(id: 1, updatedAt: DateTime.now()),
    );

    try {
      await _local.update(model);
      await _remote.updateCurrent(model);
      return const Right(unit);
    } on LocationUnauthenticatedException catch (e) {
      return Left(
        _failure(
          LocationFailureKind.unauthenticated,
          'You must be signed in to update a location.',
          e,
        ),
      );
    } on FirebaseException catch (e) {
      return Left(_mapFirebaseFailure(e));
    } catch (e) {
      return Left(
        _failure(
          LocationFailureKind.database,
          'Unable to update your location.',
          e,
        ),
      );
    }
  }

  @override
  Future<Either<LocationFailure, Unit>> deleteCurrentLocation() async {
    try {
      await _local.deleteCurrent();
      await _remote.deleteCurrent();
      return const Right(unit);
    } on LocationUnauthenticatedException catch (e) {
      return Left(
        _failure(
          LocationFailureKind.unauthenticated,
          'You must be signed in to delete your location.',
          e,
        ),
      );
    } on FirebaseException catch (e) {
      return Left(_mapFirebaseFailure(e));
    } catch (e) {
      return Left(
        _failure(
          LocationFailureKind.database,
          'Unable to delete your location.',
          e,
        ),
      );
    }
  }

  Future<void> _safeDeleteLocal() async {
    try {
      await _local.deleteCurrent();
    } catch (_) {}
  }

  LocationFailure _mapFirebaseFailure(FirebaseException e) {
    switch (e.code) {
      case 'permission-denied':
        return _failure(
          LocationFailureKind.permissionDeniedRemote,
          'You do not have permission to save this location.',
          e,
          code: e.code,
        );
      case 'unavailable':
      case 'deadline-exceeded':
        return _failure(
          LocationFailureKind.network,
          'Firebase is temporarily unavailable. Try again.',
          e,
          code: e.code,
        );
      default:
        return _failure(
          LocationFailureKind.network,
          'Unable to communicate with Firebase.',
          e,
          code: e.code,
        );
    }
  }

  LocationFailure _failure(
    LocationFailureKind kind,
    String message,
    Object cause, {
    String? code,
  }) {
    return LocationFailure(
      kind: kind,
      message: message,
      cause: cause,
      code: code,
    );
  }
}
