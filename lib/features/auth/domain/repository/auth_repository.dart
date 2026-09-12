import 'package:dartz/dartz.dart';

import 'package:demix/core/errors/app_failure.dart';
import 'package:demix/features/auth/domain/entities/auth_session.dart';

abstract interface class AuthRepository {
  Stream<AuthSession?> get authStateChanges;

  Future<Either<AppFailure, AuthSession>> signInWithEmail({
    required String email,
    required String password,
  });

  Future<Either<AppFailure, AuthSession>> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
  });

  Future<Either<AppFailure, Unit>> sendPasswordResetEmail({
    required String email,
  });

  Future<Either<AppFailure, AuthSession>> signInAsGuest();

  Future<Either<AppFailure, AuthSession>> signInWithGoogle();

  Future<Either<AppFailure, AuthSession>> signInWithFacebook();

  Future<Either<AppFailure, Unit>> signOut();
}
