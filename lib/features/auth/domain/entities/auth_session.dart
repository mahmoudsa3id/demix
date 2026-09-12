enum AuthProviderType { google, facebook, guest, account }

enum UserRole { customer, business, driver, deliveryCompany, admin }

class AuthSession {
  const AuthSession({
    required this.userId,
    required this.provider,
    required this.roles,
    this.phone,
    this.email,
    this.displayName,
    this.avatarUrl,
    this.isAnonymous = false,
  });

  final String userId;
  final AuthProviderType provider;
  final Set<UserRole> roles;

  final String? phone;
  final String? email;
  final String? displayName;
  final String? avatarUrl;

  final bool isAnonymous;

  bool get isAuthenticated => !isAnonymous && userId.isNotEmpty;

  bool get isCustomer => roles.contains(UserRole.customer);
}

class AuthParams {
  const AuthParams({this.email, this.password, this.displayName});

  final String? email;
  final String? password;
  final String? displayName;
}
