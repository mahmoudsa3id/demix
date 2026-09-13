import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demix/features/location/presentation/cubit/saved_location_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

import '../../data/datasources/device/location_device_data_source.dart';
import '../../data/datasources/geocoding/nominatim_geocoding_data_source.dart';
import '../../data/datasources/local/location_local_data_source.dart';
import '../../data/datasources/remote/location_firestore_data_source.dart';
import '../../data/datasources/zone/kafr_el_dawar_zones.dart';
import '../../data/datasources/zone/local_service_zone_checker.dart';
import '../../data/datasources/zone/service_zone_checker.dart';
import '../../data/repositories/location_repository_impl.dart';
import '../../domain/repositories/location_repository.dart';
import '../../domain/use_cases/check_service_zone_use_case.dart';
import '../../domain/use_cases/delete_current_location_use_case.dart';
import '../../domain/use_cases/get_current_device_location_use_case.dart';
import '../../domain/use_cases/get_saved_location_use_case.dart';
import '../../domain/use_cases/reverse_geocode_use_case.dart';
import '../../domain/use_cases/save_current_location_use_case.dart';
import '../../domain/use_cases/update_current_location_use_case.dart';
import '../../presentation/cubit/location_cubit.dart';

final GetIt getIt = GetIt.instance;

void setupLocationDependencies({
  required String userAgent,
  String languageCode = 'ar',
}) {
  if (!getIt.isRegistered<LocationDeviceDataSource>()) {
    getIt.registerLazySingleton<LocationDeviceDataSource>(
      LocationDeviceDataSource.new,
    );
  }

  if (!getIt.isRegistered<NominatimGeocodingDataSource>()) {
    getIt.registerLazySingleton<NominatimGeocodingDataSource>(
      () => NominatimGeocodingDataSource(
        userAgent: userAgent,
        languageCode: languageCode,
      ),
    );
  }

  if (!getIt.isRegistered<LocationLocalDataSource>()) {
    getIt.registerLazySingleton<LocationLocalDataSource>(
      LocationLocalDataSource.new,
    );
  }
  getIt.registerFactory<SavedLocationCubit>(
    () =>
        SavedLocationCubit(getSavedLocation: getIt<GetSavedLocationUseCase>()),
  );
  if (!getIt.isRegistered<LocationFirestoreDataSource>()) {
    getIt.registerLazySingleton<LocationFirestoreDataSource>(
      () => LocationFirestoreDataSource(
        auth: getIt.isRegistered<FirebaseAuth>()
            ? getIt<FirebaseAuth>()
            : FirebaseAuth.instance,
        firestore: getIt.isRegistered<FirebaseFirestore>()
            ? getIt<FirebaseFirestore>()
            : FirebaseFirestore.instance,
      ),
    );
  }

  if (!getIt.isRegistered<ServiceZoneChecker>()) {
    getIt.registerLazySingleton<ServiceZoneChecker>(
      () => const LocalServiceZoneChecker(demixServiceZones),
    );
  }

  if (!getIt.isRegistered<LocationRepository>()) {
    getIt.registerLazySingleton<LocationRepository>(
      () => LocationRepositoryImpl(
        device: getIt<LocationDeviceDataSource>(),
        geocoding: getIt<NominatimGeocodingDataSource>(),
        local: getIt<LocationLocalDataSource>(),
        remote: getIt<LocationFirestoreDataSource>(),
        zoneChecker: getIt<ServiceZoneChecker>(),
      ),
    );
  }

  if (!getIt.isRegistered<GetCurrentDeviceLocationUseCase>()) {
    getIt.registerLazySingleton<GetCurrentDeviceLocationUseCase>(
      () => GetCurrentDeviceLocationUseCase(getIt<LocationRepository>()),
    );
  }

  if (!getIt.isRegistered<ReverseGeocodeUseCase>()) {
    getIt.registerLazySingleton<ReverseGeocodeUseCase>(
      () => ReverseGeocodeUseCase(getIt<LocationRepository>()),
    );
  }

  if (!getIt.isRegistered<CheckServiceZoneUseCase>()) {
    getIt.registerLazySingleton<CheckServiceZoneUseCase>(
      () => CheckServiceZoneUseCase(getIt<LocationRepository>()),
    );
  }

  if (!getIt.isRegistered<SaveCurrentLocationUseCase>()) {
    getIt.registerLazySingleton<SaveCurrentLocationUseCase>(
      () => SaveCurrentLocationUseCase(getIt<LocationRepository>()),
    );
  }

  if (!getIt.isRegistered<GetSavedLocationUseCase>()) {
    getIt.registerLazySingleton<GetSavedLocationUseCase>(
      () => GetSavedLocationUseCase(getIt<LocationRepository>()),
    );
  }

  if (!getIt.isRegistered<UpdateCurrentLocationUseCase>()) {
    getIt.registerLazySingleton<UpdateCurrentLocationUseCase>(
      () => UpdateCurrentLocationUseCase(getIt<LocationRepository>()),
    );
  }

  if (!getIt.isRegistered<DeleteCurrentLocationUseCase>()) {
    getIt.registerLazySingleton<DeleteCurrentLocationUseCase>(
      () => DeleteCurrentLocationUseCase(getIt<LocationRepository>()),
    );
  }

  if (!getIt.isRegistered<LocationCubit>()) {
    getIt.registerFactory<LocationCubit>(
      () => LocationCubit(
        getCurrentLocation: getIt<GetCurrentDeviceLocationUseCase>(),
        reverseGeocode: getIt<ReverseGeocodeUseCase>(),
        checkServiceZone: getIt<CheckServiceZoneUseCase>(),
        saveCurrentLocation: getIt<SaveCurrentLocationUseCase>(),
      ),
    );
  }
}
