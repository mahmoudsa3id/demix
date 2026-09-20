import 'package:demix/features/favorite/domain/entities/favourite_entity.dart';

abstract class FavoritesRepository {
  Future<List<FavoriteEntity>> getFavorites(String userId);

  Future<bool> isFavorite(String userId, String favoriteId);

  Future<void> addFavorite(String userId, FavoriteEntity favorite);

  Future<void> removeFavorite(String userId, String favoriteId);
}
