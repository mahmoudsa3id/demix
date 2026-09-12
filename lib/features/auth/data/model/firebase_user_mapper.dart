import 'package:demix/features/auth/data/model/auth_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:demix/features/auth/domain/entities/auth_session.dart';

class FirebaseUserModelMapper {
  const FirebaseUserModelMapper._();

  static AuthModel fromFirebaseUser(User user, {required Set<UserRole> roles}) {
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
