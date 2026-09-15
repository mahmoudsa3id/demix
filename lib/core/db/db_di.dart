import 'package:get_it/get_it.dart';

import 'db.dart';

void setupDatabaseDependencies(GetIt getIt) {
  if (!getIt.isRegistered<AppDatabase>()) {
    getIt.registerLazySingleton<AppDatabase>(AppDatabase.new);
  }
}
