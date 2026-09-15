import 'package:demix/core/errors/app_failure.dart';
import 'package:demix/features/account/domain/entities/account_user.dart';

sealed class AccountState {
  const AccountState();
}

class AccountInitial extends AccountState {
  const AccountInitial();
}

class AccountLoading extends AccountState {
  const AccountLoading();
}

class AccountLoaded extends AccountState {
  const AccountLoaded(this.user);

  final AccountUser user;
}

class AccountUpdating extends AccountState {
  const AccountUpdating(this.user);

  final AccountUser user;
}

class AccountDeleting extends AccountState {
  const AccountDeleting();
}

class AccountDeleted extends AccountState {
  const AccountDeleted();
}

class AccountFailure extends AccountState {
  const AccountFailure(this.failure, {this.previousUser});

  final AppFailure failure;
  final AccountUser? previousUser;
}
