import 'package:dartz/dartz.dart';
import '../../core/errors/location_failure.dart';
import '../entities/location_coordinate.dart';
import '../entities/location_entity.dart';
import '../repositories/location_repository.dart';

class ReverseGeocodeUseCase {
  const ReverseGeocodeUseCase(this._repository);
  final LocationRepository _repository;

  Future<Either<LocationFailure, LocationEntity>> call(LocationCoordinate coordinate) =>
      _repository.reverseGeocode(coordinate);
}
