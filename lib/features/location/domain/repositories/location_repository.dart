import 'package:dartz/dartz.dart';

import '../../core/errors/location_failure.dart';
import '../entities/location_coordinate.dart';
import '../entities/location_entity.dart';
import '../entities/service_zone.dart';

abstract interface class LocationRepository {
  Future<Either<LocationFailure, LocationCoordinate>> getCurrentDeviceLocation();

  Future<Either<LocationFailure, LocationEntity>> reverseGeocode(
    LocationCoordinate coordinate,
  );

  Future<Either<LocationFailure, ServiceZoneMatch>> checkServiceZone(
    LocationCoordinate coordinate,
  );

  Future<Either<LocationFailure, LocationEntity>> saveCurrentLocation(
    LocationEntity location,
  );

  Future<Either<LocationFailure, LocationEntity?>> getSavedLocation();

  Future<Either<LocationFailure, Unit>> updateCurrentLocation(
    LocationEntity location,
  );

  Future<Either<LocationFailure, Unit>> deleteCurrentLocation();
}
