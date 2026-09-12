import 'package:dartz/dartz.dart';
import 'package:demix/core/errors/app_failure.dart';

abstract class UseCase<T, params> {
  Future<Either<AppFailure, T>> call([params? params]);
}

class NoParams {
  const NoParams();
}
