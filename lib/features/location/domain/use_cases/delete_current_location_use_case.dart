import 'package:dartz/dartz.dart';
import '../../core/errors/location_failure.dart';
import '../repositories/location_repository.dart';

class DeleteCurrentLocationUseCase {
  const DeleteCurrentLocationUseCase(this._repository);

  final LocationRepository _repository;

  Future<Either<LocationFailure, Unit>> call() =>
      _repository.deleteCurrentLocation();
}
