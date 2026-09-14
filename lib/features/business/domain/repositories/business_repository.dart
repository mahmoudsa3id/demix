import 'package:dartz/dartz.dart';

import '../../../../core/errors/app_failure.dart';
import '../entities/business.dart';

abstract interface class BusinessRepository {
  Future<Either<AppFailure, List<Business>>>
      getBusinessesByType(String type);
}
