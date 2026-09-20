import 'package:demix/features/favorite/domain/entities/favourite_entity.dart';
import 'package:demix/features/favorite/domain/use_cases/get_favorites_use_case.dart';
import 'package:demix/features/favorite/domain/use_cases/remove_favorites_use_case.dart';
import 'package:demix/features/favorite/domain/use_cases/toggle_favorite_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

sealed class FavoritesState {
  const FavoritesState();
}

class FavoritesInitial extends FavoritesState {
  const FavoritesInitial();
}

class FavoritesLoading extends FavoritesState {
  const FavoritesLoading();
}

class FavoritesLoaded extends FavoritesState {
  const FavoritesLoaded(this.favorites);

  final List<FavoriteEntity> favorites;

  List<FavoriteEntity> get restaurants {
    return favorites
        .where((item) => item.type == FavoriteType.restaurant)
        .toList();
  }

  List<FavoriteEntity> get cafes {
    return favorites.where((item) => item.type == FavoriteType.cafe).toList();
  }

  List<FavoriteEntity> get products {
    return favorites
        .where((item) => item.type == FavoriteType.product)
        .toList();
  }

  bool contains(String id) {
    return favorites.any((item) => item.id == id);
  }
}

class FavoritesFailure extends FavoritesState {
  const FavoritesFailure(this.message);

  final String message;
}

class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit({
    required this._getFavorites,
    required this._toggleFavorite,
    required this._removeFavorite,
    required this._userId,
  }) : super(const FavoritesInitial());

  final GetFavoritesUseCase _getFavorites;
  final ToggleFavoriteUseCase _toggleFavorite;
  final RemoveFavoriteUseCase _removeFavorite;

  final String _userId;

  Future<void> load() async {
    if (isClosed) return;

    emit(const FavoritesLoading());

    try {
      final favorites = await _getFavorites(_userId);

      if (isClosed) return;

      emit(FavoritesLoaded(favorites));
    } catch (e) {
      if (isClosed) return;

      emit(FavoritesFailure(e.toString()));
    }
  }

  Future<void> toggle(FavoriteEntity favorite) async {
    try {
      await _toggleFavorite(_userId, favorite);

      await load();
    } catch (e) {
      if (isClosed) return;

      emit(FavoritesFailure(e.toString()));
    }
  }

  Future<void> remove(String favoriteId) async {
    try {
      await _removeFavorite(_userId, favoriteId);

      await load();
    } catch (e) {
      if (isClosed) return;

      emit(FavoritesFailure(e.toString()));
    }
  }
}
