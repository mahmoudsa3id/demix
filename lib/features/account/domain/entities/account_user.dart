import 'package:equatable/equatable.dart';

class AccountUser extends Equatable {
  const AccountUser({
    required this.id,
    this.displayName,
    this.email,
    this.phone,
    this.avatarUrl,
  });

  final String id;
  final String? displayName;
  final String? email;
  final String? phone;
  final String? avatarUrl;

  String get safeName {
    final value = displayName?.trim();

    if (value == null || value.isEmpty) {
      return 'User';
    }

    return value;
  }

  @override
  List<Object?> get props => [id, displayName, email, phone, avatarUrl];
}
