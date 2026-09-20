import 'package:demix/features/favorite/data/data_sources/favourite_local_data_source.dart';
import 'package:demix/features/favorite/data/model/favourite_model.dart';
import 'package:demix/features/favorite/domain/entities/favourite_entity.dart';
import 'package:demix/features/favorite/domain/repository/favorites_repository.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  FavoritesRepositoryImpl({required this._localDataSource});

  final FavoritesLocalDataSource _localDataSource;

  @override
  Future<List<FavoriteEntity>> getFavorites(String userId) {
    return _localDataSource.getFavorites(userId);
  }

  @override
  Future<bool> isFavorite(String userId, String favoriteId) {
    return _localDataSource.isFavorite(userId, favoriteId);
  }

  @override
  Future<void> addFavorite(String userId, FavoriteEntity favorite) {
    final model = FavoriteModel(
      id: favorite.id,
      type: favorite.type,
      itemId: favorite.itemId,
      name: favorite.name,
      nameAr: favorite.nameAr,
      imageUrl: favorite.imageUrl,
      coverUrl: favorite.coverUrl,
      logoUrl: favorite.logoUrl,
      rating: favorite.rating,
      reviewCount: favorite.reviewCount,
      price: favorite.price,
      businessId: favorite.businessId,
      businessName: favorite.businessName,
      businessLogo: favorite.businessLogo,
      businessRating: favorite.businessRating,
    );

    return _localDataSource.addFavorite(userId, model);
  }

  @override
  Future<void> removeFavorite(String userId, String favoriteId) {
    return _localDataSource.removeFavorite(userId, favoriteId);
  }
}
