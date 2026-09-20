import 'package:demix/features/favorite/domain/entities/favourite_entity.dart';
import 'package:demix/features/favorite/domain/repository/favorites_repository.dart';

class GetFavoritesUseCase {
  const GetFavoritesUseCase(this._repository);

  final FavoritesRepository _repository;

  Future<List<FavoriteEntity>> call(String userId) {
    return _repository.getFavorites(userId);
  }
}
