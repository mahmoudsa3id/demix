import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demix/features/account/domain/entities/account_user.dart';

class AccountUserModel extends AccountUser {
  const AccountUserModel({
    required super.id,
    super.displayName,
    super.email,
    super.phone,
    super.avatarUrl,
  });

  factory AccountUserModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data() ?? {};

    return AccountUserModel(
      id: snapshot.id,
      displayName: _nullableString(data['displayName']),
      email: _nullableString(data['email']),
      phone: _nullableString(data['phone']),
      avatarUrl: _nullableString(data['avatarUrl']),
    );
  }

  factory AccountUserModel.fromMap(String id, Map<String, dynamic> data) {
    return AccountUserModel(
      id: id,
      displayName: _nullableString(data['displayName']),
      email: _nullableString(data['email']),
      phone: _nullableString(data['phone']),
      avatarUrl: _nullableString(data['avatarUrl']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'displayName': displayName,
      'email': email,
      'phone': phone,
      'avatarUrl': avatarUrl,
    };
  }

  static String? _nullableString(dynamic value) {
    if (value == null) return null;

    final result = value.toString().trim();

    return result.isEmpty ? null : result;
  }
}
