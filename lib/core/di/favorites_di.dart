import 'package:demix/features/favorite/data/data_sources/favorites_local_data_base_impl.dart';
import 'package:demix/features/favorite/data/data_sources/favourite_local_data_source.dart';
import 'package:demix/features/favorite/data/repository/favorites_repository_impl.dart';
import 'package:demix/features/favorite/domain/repository/favorites_repository.dart';
import 'package:demix/features/favorite/domain/use_cases/get_favorites_use_case.dart';
import 'package:demix/features/favorite/domain/use_cases/remove_favorites_use_case.dart';
import 'package:demix/features/favorite/domain/use_cases/toggle_favorite_use_case.dart';
import 'package:demix/features/favorite/presentation/cubit/favorites_cubit.dart';
import 'package:get_it/get_it.dart';

void setupFavoritesDependencies(GetIt getIt) {
  getIt.registerLazySingleton<FavoritesLocalDataSource>(
    () => FavoritesLocalDataSourceImpl(database: getIt()),
  );

  getIt.registerLazySingleton<FavoritesRepository>(
    () => FavoritesRepositoryImpl(localDataSource: getIt()),
  );

  getIt.registerLazySingleton<GetFavoritesUseCase>(
    () => GetFavoritesUseCase(getIt()),
  );

  getIt.registerLazySingleton<ToggleFavoriteUseCase>(
    () => ToggleFavoriteUseCase(getIt()),
  );

  getIt.registerLazySingleton<RemoveFavoriteUseCase>(
    () => RemoveFavoriteUseCase(getIt()),
  );

  getIt.registerFactoryParam<FavoritesCubit, String, void>(
    (userId, _) => FavoritesCubit(
      getFavorites: getIt(),
      toggleFavorite: getIt(),
      removeFavorite: getIt(),
      userId: userId,
    ),
  );
}
