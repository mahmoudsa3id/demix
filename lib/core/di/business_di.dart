import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demix/features/business/domain/use_cases/get_all_business_use_cases.dart';
import 'package:demix/features/business/domain/use_cases/get_business_page_use_cases.dart';
import 'package:demix/features/business/presentation/cubit/test.dart';
import 'package:get_it/get_it.dart';
import 'package:demix/features/business/data/datasources/business_remote_data_source.dart';
import 'package:demix/features/business/data/repositories/business_repository_impl.dart';
import 'package:demix/features/business/domain/repositories/business_repository.dart';
import 'package:demix/features/business/domain/use_cases/get_business_by_id_use_case.dart';
import 'package:demix/features/business/domain/use_cases/get_business_categories_use_case.dart';
import 'package:demix/features/business/domain/use_cases/get_business_products_use_case.dart';
import 'package:demix/features/business/domain/use_cases/get_businesses_by_type_use_case.dart';
import 'package:demix/features/business/presentation/cubit/business_cubit.dart';
import 'package:demix/features/business/presentation/cubit/business_profile_cubit.dart';

void setupBusinessDependencies(GetIt getIt) {
  if (!getIt.isRegistered<BusinessRemoteDataSource>()) {
    getIt.registerLazySingleton<BusinessRemoteDataSource>(
      () => FirebaseBusinessRemoteDataSource(
        firestore: getIt<FirebaseFirestore>(),
      ),
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

  if (!getIt.isRegistered<GetBusinessByIdUseCase>()) {
    getIt.registerLazySingleton<GetBusinessByIdUseCase>(
      () => GetBusinessByIdUseCase(getIt<BusinessRepository>()),
    );
  }

  if (!getIt.isRegistered<GetBusinessCategoriesUseCase>()) {
    getIt.registerLazySingleton<GetBusinessCategoriesUseCase>(
      () => GetBusinessCategoriesUseCase(getIt<BusinessRepository>()),
    );
  }

  if (!getIt.isRegistered<GetBusinessProductsUseCase>()) {
    getIt.registerLazySingleton<GetBusinessProductsUseCase>(
      () => GetBusinessProductsUseCase(getIt<BusinessRepository>()),
    );
  }
  getIt.registerLazySingleton<GetAllBusinessesUseCase>(
    () => GetAllBusinessesUseCase(repository: getIt<BusinessRepository>()),
  );
  getIt.registerLazySingleton<GetBusinessesPageUseCase>(
    () => GetBusinessesPageUseCase(repository: getIt<BusinessRepository>()),
  );
  if (!getIt.isRegistered<BusinessCubit>()) {
    getIt.registerFactory<BusinessCubit>(
      () => BusinessCubit(
        getBusinessesByType: getIt<GetBusinessesByTypeUseCase>(),
        getBusinessesPage: getIt<GetBusinessesPageUseCase>(),
        getAllBusinesses: getIt<GetAllBusinessesUseCase>(),
      ),
    );
  }
  getIt.registerLazySingleton<BusinessMockSeeder>(
    () => BusinessMockSeeder(firestore: FirebaseFirestore.instance),
  );
  if (!getIt.isRegistered<BusinessProfileCubit>()) {
    getIt.registerFactory<BusinessProfileCubit>(
      () => BusinessProfileCubit(
        getBusinessById: getIt<GetBusinessByIdUseCase>(),
        getBusinessCategories: getIt<GetBusinessCategoriesUseCase>(),
        getBusinessProducts: getIt<GetBusinessProductsUseCase>(),
      ),
    );
  }
}
