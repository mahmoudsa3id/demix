import 'package:demix/features/favorite/domain/repository/favorites_repository.dart';

class RemoveFavoriteUseCase {
  const RemoveFavoriteUseCase(this._repository);

  final FavoritesRepository _repository;

  Future<void> call(String userId, String favoriteId) {
    return _repository.removeFavorite(userId, favoriteId);
  }
}
