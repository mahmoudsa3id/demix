import 'package:demix/core/errors/app_failure.dart';
import 'package:demix/features/auth/domain/entities/auth_session.dart';

sealed class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class Authenticated extends AuthState {
  const Authenticated(this.session);

  final AuthSession session;
}

class GuestSession extends AuthState {
  const GuestSession();
}

class Unauthenticated extends AuthState {
  const Unauthenticated();
}

class AuthPasswordResetSent extends AuthState {
  const AuthPasswordResetSent();
}

class AuthFailed extends AuthState {
  const AuthFailed(this.failure);

  final AppFailure failure;
}
