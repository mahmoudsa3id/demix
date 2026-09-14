import 'package:dartz/dartz.dart';

import '../../../../core/errors/app_failure.dart';
import '../entities/business.dart';
import '../repositories/business_repository.dart';

class GetBusinessesByTypeUseCase {
  const GetBusinessesByTypeUseCase(
    this._repository,
  );

  final BusinessRepository _repository;

  Future<Either<AppFailure, List<Business>>> call(
    String type,
  ) {
    return _repository.getBusinessesByType(type);
  }
}
