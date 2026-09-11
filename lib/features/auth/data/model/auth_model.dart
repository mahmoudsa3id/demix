import 'package:demix/features/auth/domain/entities/auth_session.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthModel extends AuthSession {
  const AuthModel({
    required super.userId,
    required super.provider,
    required super.roles,
    super.phone,
    super.email,
    super.displayName,
    super.avatarUrl,
    super.isAnonymous,
  });

  factory AuthModel.fromFirebaseUser(
    User user, {
    required Set<UserRole> roles,
  }) {
    return AuthModel(
      userId: user.uid,
      provider: _mapProvider(user),
      roles: roles,
      phone: user.phoneNumber,
      email: user.email,
      displayName: user.displayName,
      avatarUrl: user.photoURL,
      isAnonymous: user.isAnonymous,
    );
  }

  factory AuthModel.fromEntity(AuthSession entity) {
    return AuthModel(
      userId: entity.userId,
      provider: entity.provider,
      roles: entity.roles,
      phone: entity.phone,
      email: entity.email,
      displayName: entity.displayName,
      avatarUrl: entity.avatarUrl,
      isAnonymous: entity.isAnonymous,
    );
  }

  AuthSession toEntity() {
    return AuthSession(
      userId: userId,
      provider: provider,
      roles: roles,
      phone: phone,
      email: email,
      displayName: displayName,
      avatarUrl: avatarUrl,
      isAnonymous: isAnonymous,
    );
  }

  static AuthProviderType _mapProvider(User user) {
    if (user.isAnonymous) {
      return AuthProviderType.guest;
    }

    final providers = user.providerData
        .map((provider) => provider.providerId)
        .toSet();

    if (providers.contains('google.com')) {
      return AuthProviderType.google;
    }

    if (providers.contains('facebook.com')) {
      return AuthProviderType.facebook;
    }

    return AuthProviderType.account;
  }
}
