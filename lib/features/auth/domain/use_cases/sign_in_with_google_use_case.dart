import 'package:dartz/dartz.dart';
import 'package:demix/core/errors/app_failure.dart';
import 'package:demix/core/utils/helper/use_case.dart';
import 'package:demix/features/auth/domain/entities/auth_session.dart';
import 'package:demix/features/auth/domain/repository/auth_repository.dart';

class SignInWithGoogleUseCase implements UseCase<AuthSession, NoParams> {
  const SignInWithGoogleUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<AppFailure, AuthSession>> call([NoParams? params]) {
    return _repository.signInWithGoogle();
  }
}
