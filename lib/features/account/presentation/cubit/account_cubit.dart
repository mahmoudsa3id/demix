import 'package:demix/features/account/domain/use_cases/delete_account_user_use_cases.dart';
import 'package:demix/features/account/domain/use_cases/get_account_user_use_cases.dart';
import 'package:demix/features/account/domain/use_cases/update_account_user_use_cases.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'account_state.dart';

class AccountCubit extends Cubit<AccountState> {
  AccountCubit({
    required this._getAccountUser,
    required this._updateProfile,
    required this._deleteAccount,
  }) : super(const AccountInitial());

  final GetAccountUserUseCase _getAccountUser;
  final UpdateAccountProfileUseCase _updateProfile;
  final DeleteAccountUseCase _deleteAccount;

  Future<void> load() async {
    emit(const AccountLoading());

    final result = await _getAccountUser();

    result.fold(
      (failure) {
        emit(AccountFailure(failure));
      },
      (user) {
        emit(AccountLoaded(user));
      },
    );
  }

  Future<void> updateProfile({
    required String displayName,
    String? phone,
  }) async {
    final currentUser = state is AccountLoaded
        ? (state as AccountLoaded).user
        : state is AccountUpdating
        ? (state as AccountUpdating).user
        : null;

    if (currentUser != null) {
      emit(AccountUpdating(currentUser));
    } else {
      emit(const AccountLoading());
    }

    final result = await _updateProfile(displayName: displayName, phone: phone);

    result.fold(
      (failure) {
        emit(AccountFailure(failure, previousUser: currentUser));
      },
      (user) {
        emit(AccountLoaded(user));
      },
    );
  }

  Future<void> deleteAccount() async {
    emit(const AccountDeleting());

    final result = await _deleteAccount();

    result.fold(
      (failure) {
        emit(AccountFailure(failure));
      },
      (_) {
        emit(const AccountDeleted());
      },
    );
  }
}
