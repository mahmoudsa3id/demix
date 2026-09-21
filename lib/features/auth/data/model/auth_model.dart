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

  factory AuthModel.fromMap(Map<String, dynamic> map, {required User user}) {
    return AuthModel(
      userId: user.uid,
      provider: _mapProvider(user),
      roles: _mapRoles(map['roles']),
      phone: map['phone']?.toString() ?? user.phoneNumber,
      email: map['email']?.toString() ?? user.email,
      displayName: map['displayName']?.toString() ?? user.displayName,
      avatarUrl: map['avatarUrl']?.toString() ?? user.photoURL,
      isAnonymous: user.isAnonymous,
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

  static Set<UserRole> _mapRoles(dynamic value) {
    if (value is! List) return {};

    return value
        .whereType<String>()
        .map(
          (name) => UserRole.values.firstWhere(
            (role) => role.name == name,
            orElse: () => UserRole.customer,
          ),
        )
        .toSet();
  }

  static AuthProviderType _mapProvider(User user) {
    if (user.isAnonymous) {
      return AuthProviderType.guest;
    }

    final providers = user.providerData.map((e) => e.providerId).toSet();

    if (providers.contains('google.com')) {
      return AuthProviderType.google;
    }

    if (providers.contains('facebook.com')) {
      return AuthProviderType.facebook;
    }

    return AuthProviderType.account;
  }
}
