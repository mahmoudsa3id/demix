import 'package:dartz/dartz.dart';

import 'package:demix/core/errors/app_failure.dart';
import 'package:demix/core/utils/helper/use_case.dart';
import 'package:demix/features/auth/domain/entities/auth_session.dart';
import 'package:demix/features/auth/domain/repository/auth_repository.dart';

class SignInWithEmailUseCase implements UseCase<AuthSession, AuthParams> {
  const SignInWithEmailUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<AppFailure, AuthSession>> call([AuthParams? params]) {
    if (params == null || params.email == null || params.password == null) {
      return Future.value(
        const Left(
          AppFailure(
            kind: FailureKind.validation,
            message: 'Email and password are required.',
          ),
        ),
      );
    }

    return _repository.signInWithEmail(
      email: params.email!,
      password: params.password!,
    );
  }
}
