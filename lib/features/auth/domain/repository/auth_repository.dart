import 'package:demix/features/auth/domain/entities/auth_session.dart';

abstract class AuthRepository {
  Stream<AuthSession>? get authstateChanges;
  Future<AuthSession> signInWithEmail({
    required String email,
    required String password,
  });

  Future<AuthSession> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
  });

  Future<void> sendPasswordResetEmail({required String email});

  Future<AuthSession> signInAsGuest();

  Future<AuthSession> signInWithGoogle();

  Future<AuthSession> signInWithFacebook();

  Future<void> signOut();
}
