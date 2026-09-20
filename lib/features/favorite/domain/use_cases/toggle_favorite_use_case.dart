import 'package:demix/features/favorite/domain/entities/favourite_entity.dart';
import 'package:demix/features/favorite/domain/repository/favorites_repository.dart';

class ToggleFavoriteUseCase {
  const ToggleFavoriteUseCase(this._repository);

  final FavoritesRepository _repository;

  Future<bool> call(String userId, FavoriteEntity favorite) async {
    final exists = await _repository.isFavorite(userId, favorite.id);

    if (exists) {
      await _repository.removeFavorite(userId, favorite.id);

      return false;
    }

    await _repository.addFavorite(userId, favorite);

    return true;
  }
}
