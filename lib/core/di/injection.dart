import 'package:get_it/get_it.dart';

import 'account_di.dart';
import 'auth_di.dart';
import 'business_di.dart';
import 'db_di.dart';
import 'favorites_di.dart';
import 'location_di.dart';
import 'ordering_di.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  setupDatabaseDependencies(getIt);

  setupAuthDependencies(getIt);

  setupLocationDependencies(
    getIt,
    userAgent: 'DeMiX/1.0 (mahmoud.said.developer@gmail.com)',
    languageCode: 'ar',
  );

  setupBusinessDependencies(getIt);

  setupOrderingDependencies(getIt);

  setupAccountDependencies(getIt);

  setupFavoritesDependencies(getIt);
}
