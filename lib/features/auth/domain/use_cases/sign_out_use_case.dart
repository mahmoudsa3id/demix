import 'package:dartz/dartz.dart';

import 'package:demix/core/errors/app_failure.dart';
import 'package:demix/core/utils/helper/use_case.dart';
import 'package:demix/features/auth/domain/repository/auth_repository.dart';

class SignOutUseCase implements UseCase<Unit, NoParams> {
  const SignOutUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<AppFailure, Unit>> call([NoParams? params]) {
    return _repository.signOut();
  }
}
