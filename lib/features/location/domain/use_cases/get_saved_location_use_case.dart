import 'package:dartz/dartz.dart';
import '../../core/errors/location_failure.dart';
import '../entities/location_entity.dart';
import '../repositories/location_repository.dart';

class GetSavedLocationUseCase {
  const GetSavedLocationUseCase(this._repository);
  final LocationRepository _repository;

  Future<Either<LocationFailure, LocationEntity?>> call() =>
      _repository.getSavedLocation();
}
