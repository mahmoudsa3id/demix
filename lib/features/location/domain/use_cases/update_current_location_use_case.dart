import 'package:dartz/dartz.dart';
import '../../core/errors/location_failure.dart';
import '../entities/location_entity.dart';
import '../repositories/location_repository.dart';

class UpdateCurrentLocationUseCase {
  const UpdateCurrentLocationUseCase(this._repository);
  final LocationRepository _repository;

  Future<Either<LocationFailure, Unit>> call(LocationEntity location) =>
      _repository.updateCurrentLocation(location);
}
