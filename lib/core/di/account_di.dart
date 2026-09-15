import 'package:demix/features/account/data/data_source/account_remote_data_source.dart';
import 'package:demix/features/account/data/repositories/account_repository_impl.dart';
import 'package:demix/features/account/domain/repositories/account_repository.dart';
import 'package:demix/features/account/domain/use_cases/delete_account_user_use_cases.dart';
import 'package:demix/features/account/domain/use_cases/get_account_user_use_cases.dart';
import 'package:demix/features/account/domain/use_cases/update_account_user_use_cases.dart';
import 'package:demix/features/account/presentation/cubit/account_cubit.dart';
import 'package:get_it/get_it.dart';

void setupAccountDependencies(GetIt getIt) {
  if (!getIt.isRegistered<AccountRemoteDataSource>()) {
    getIt.registerLazySingleton<AccountRemoteDataSource>(
      FirebaseAccountRemoteDataSource.new,
    );
  }

  if (!getIt.isRegistered<AccountRepository>()) {
    getIt.registerLazySingleton<AccountRepository>(
      () => AccountRepositoryImpl(
        remoteDataSource: getIt<AccountRemoteDataSource>(),
      ),
    );
  }

  if (!getIt.isRegistered<GetAccountUserUseCase>()) {
    getIt.registerLazySingleton<GetAccountUserUseCase>(
      () => GetAccountUserUseCase(getIt<AccountRepository>()),
    );
  }

  if (!getIt.isRegistered<UpdateAccountProfileUseCase>()) {
    getIt.registerLazySingleton<UpdateAccountProfileUseCase>(
      () => UpdateAccountProfileUseCase(getIt<AccountRepository>()),
    );
  }

  if (!getIt.isRegistered<DeleteAccountUseCase>()) {
    getIt.registerLazySingleton<DeleteAccountUseCase>(
      () => DeleteAccountUseCase(getIt<AccountRepository>()),
    );
  }

  if (!getIt.isRegistered<AccountCubit>()) {
    getIt.registerLazySingleton<AccountCubit>(
      () => AccountCubit(
        getAccountUser: getIt<GetAccountUserUseCase>(),
        updateProfile: getIt<UpdateAccountProfileUseCase>(),
        deleteAccount: getIt<DeleteAccountUseCase>(),
      ),
    );
  }
}
