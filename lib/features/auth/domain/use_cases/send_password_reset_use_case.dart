import 'package:dartz/dartz.dart';

import 'package:demix/core/errors/app_failure.dart';
import 'package:demix/core/utils/helper/use_case.dart';
import 'package:demix/features/auth/domain/entities/auth_session.dart';
import 'package:demix/features/auth/domain/repository/auth_repository.dart';

class SendPasswordResetEmailUseCase implements UseCase<Unit, AuthParams> {
  const SendPasswordResetEmailUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<AppFailure, Unit>> call([AuthParams? params]) {
    if (params == null || params.email == null) {
      return Future.value(
        const Left(
          AppFailure(
            kind: FailureKind.validation,
            message: 'Email is required.',
          ),
        ),
      );
    }

    return _repository.sendPasswordResetEmail(email: params.email!);
  }
}
