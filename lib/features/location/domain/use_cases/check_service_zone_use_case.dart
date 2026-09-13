import 'package:dartz/dartz.dart';
import '../../core/errors/location_failure.dart';
import '../entities/location_coordinate.dart';
import '../entities/service_zone.dart';
import '../repositories/location_repository.dart';

class CheckServiceZoneUseCase {
  const CheckServiceZoneUseCase(this._repository);
  final LocationRepository _repository;

  Future<Either<LocationFailure, ServiceZoneMatch>> call(LocationCoordinate coordinate) =>
      _repository.checkServiceZone(coordinate);
}
