import 'dart:async';

import 'package:demix/core/errors/app_failure.dart';
import 'package:demix/features/auth/domain/use_cases/observe_auth_state_use_case.dart';
import 'package:demix/features/auth/domain/use_cases/send_password_reset_use_case.dart';
import 'package:demix/features/auth/domain/use_cases/sign_in_as_guest_use_case.dart';
import 'package:demix/features/auth/domain/use_cases/sign_in_with_email_use_case.dart';
import 'package:demix/features/auth/domain/use_cases/sign_in_with_facebook_use_case.dart';
import 'package:demix/features/auth/domain/use_cases/sign_in_with_google_use_case.dart';
import 'package:demix/features/auth/domain/use_cases/sign_out_use_case.dart';
import 'package:demix/features/auth/domain/use_cases/sign_up_with_email_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:demix/features/auth/domain/entities/auth_session.dart';

import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required this._signInWithEmail,
    required this._signUpWithEmail,
    required this._signInWithGoogle,
    required this._signInWithFacebook,
    required this._signInAsGuest,
    required this._sendPasswordResetEmail,
    required this._signOut,
    required this._observeAuthState,
  }) : super(const AuthInitial());

  final SignInWithEmailUseCase _signInWithEmail;
  final SignUpWithEmailUseCase _signUpWithEmail;
  final SignInWithGoogleUseCase _signInWithGoogle;
  final SignInWithFacebookUseCase _signInWithFacebook;
  final SignInAsGuestUseCase _signInAsGuest;
  final SendPasswordResetEmailUseCase _sendPasswordResetEmail;
  final SignOutUseCase _signOut;
  final ObserveAuthStateUseCase _observeAuthState;

  StreamSubscription<AuthSession?>? _authSubscription;

  // ---------------------------------------------------------------------------
  // Initialize
  // ---------------------------------------------------------------------------

  void initialize() {
    _authSubscription?.cancel();

    _authSubscription = _observeAuthState().listen(
      (session) {
        if (session == null) {
          emit(const Unauthenticated());
          return;
        }

        if (session.isAnonymous) {
          emit(const GuestSession());
          return;
        }

        emit(Authenticated(session));
      },
      onError: (error) {
        emit(AuthFailed(_failureFromError(error)));
      },
    );
  }

  // ---------------------------------------------------------------------------
  // Sign In
  // ---------------------------------------------------------------------------

  Future<void> signIn({required String email, required String password}) async {
    emit(const AuthLoading());

    final result = await _signInWithEmail(
      AuthParams(email: email, password: password),
    );

    result.fold(
      (failure) => emit(AuthFailed(failure)),
      (session) => emit(Authenticated(session)),
    );
  }

  // ---------------------------------------------------------------------------
  // Sign Up
  // ---------------------------------------------------------------------------

  Future<void> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    emit(const AuthLoading());

    final result = await _signUpWithEmail(
      AuthParams(email: email, password: password, displayName: displayName),
    );

    result.fold(
      (failure) => emit(AuthFailed(failure)),
      (session) => emit(Authenticated(session)),
    );
  }

  // ---------------------------------------------------------------------------
  // Google
  // ---------------------------------------------------------------------------

  Future<void> signInWithGoogle() async {
    emit(const AuthLoading());

    final result = await _signInWithGoogle();

    result.fold(
      (failure) => emit(AuthFailed(failure)),
      (session) => emit(Authenticated(session)),
    );
  }

  // ---------------------------------------------------------------------------
  // Facebook
  // ---------------------------------------------------------------------------

  Future<void> signInWithFacebook() async {
    emit(const AuthLoading());

    final result = await _signInWithFacebook();

    result.fold(
      (failure) => emit(AuthFailed(failure)),
      (session) => emit(Authenticated(session)),
    );
  }

  // ---------------------------------------------------------------------------
  // Guest
  // ---------------------------------------------------------------------------

  Future<void> signInAsGuest() async {
    emit(const AuthLoading());

    final result = await _signInAsGuest();

    result.fold(
      (failure) => emit(AuthFailed(failure)),
      (session) => emit(
        session.isAnonymous ? const GuestSession() : Authenticated(session),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Password Reset
  // ---------------------------------------------------------------------------

  Future<void> sendPasswordResetEmail({required String email}) async {
    emit(const AuthLoading());

    final result = await _sendPasswordResetEmail(AuthParams(email: email));

    result.fold((failure) => emit(AuthFailed(failure)), (_) {
      // هنا ممكن تعمل State مخصص للـ reset success
      // لو محتاج تعرض رسالة في UI.
    });
  }

  // ---------------------------------------------------------------------------
  // Sign Out
  // ---------------------------------------------------------------------------

  Future<void> signOut() async {
    emit(const AuthLoading());

    final result = await _signOut();

    result.fold(
      (failure) => emit(AuthFailed(failure)),
      (_) => emit(const Unauthenticated()),
    );
  }

  // ---------------------------------------------------------------------------
  // Dispose
  // ---------------------------------------------------------------------------

  @override
  Future<void> close() async {
    await _authSubscription?.cancel();
    return super.close();
  }

  // ---------------------------------------------------------------------------
  // Temporary stream error mapper
  // ---------------------------------------------------------------------------

  AppFailure _failureFromError(Object error) {
    if (error is AppFailure) {
      return error;
    }

    return AppFailure(
      kind: FailureKind.unknown,
      message: error.toString(),
      cause: error,
    );
  }
}
