import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';

import '../../features/business/data/datasources/business_remote_data_source.dart';
import '../../features/business/data/repositories/business_repository_impl.dart';
import '../../features/business/domain/repositories/business_repository.dart';
import '../../features/business/domain/use_cases/get_businesses_by_type_use_case.dart';
import '../../features/business/presentation/cubit/business_cubit.dart';

void setupBusinessDependencies(GetIt getIt) {
  if (!getIt.isRegistered<BusinessRemoteDataSource>()) {
    getIt.registerLazySingleton<BusinessRemoteDataSource>(
      () => BusinessRemoteDataSource(firestore: getIt<FirebaseFirestore>()),
    );
  }

  if (!getIt.isRegistered<BusinessRepository>()) {
    getIt.registerLazySingleton<BusinessRepository>(
      () => BusinessRepositoryImpl(
        remoteDataSource: getIt<BusinessRemoteDataSource>(),
      ),
    );
  }

  if (!getIt.isRegistered<GetBusinessesByTypeUseCase>()) {
    getIt.registerLazySingleton<GetBusinessesByTypeUseCase>(
      () => GetBusinessesByTypeUseCase(getIt<BusinessRepository>()),
    );
  }

  if (!getIt.isRegistered<BusinessCubit>()) {
    getIt.registerFactory<BusinessCubit>(
      () => BusinessCubit(
        getBusinessesByType: getIt<GetBusinessesByTypeUseCase>(),
      ),
    );
  }
}
