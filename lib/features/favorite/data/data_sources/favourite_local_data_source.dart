import 'package:demix/features/favorite/data/model/favourite_model.dart';

abstract class FavoritesLocalDataSource {
  Future<List<FavoriteModel>> getFavorites(String userId);

  Future<bool> isFavorite(String userId, String favoriteId);

  Future<void> addFavorite(String userId, FavoriteModel favorite);

  Future<void> removeFavorite(String userId, String favoriteId);
}
