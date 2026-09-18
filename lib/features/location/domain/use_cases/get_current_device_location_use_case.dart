import 'package:dartz/dartz.dart';
import '../../../../core/errors/location_failure.dart';
import '../entities/location_coordinate.dart';
import '../repositories/location_repository.dart';

class GetCurrentDeviceLocationUseCase {
  const GetCurrentDeviceLocationUseCase(this._repository);
  final LocationRepository _repository;

  Future<Either<LocationFailure, LocationCoordinate>> call() =>
      _repository.getCurrentDeviceLocation();
}
