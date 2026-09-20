import 'package:demix/core/db/db.dart';
import 'package:demix/features/favorite/data/data_sources/favourite_local_data_source.dart';
import 'package:demix/features/favorite/data/model/favourite_model.dart';
import 'package:sqflite/sqflite.dart';

class FavoritesLocalDataSourceImpl implements FavoritesLocalDataSource {
  FavoritesLocalDataSourceImpl({required this._database});

  final AppDatabase _database;

  static const String _table = 'favorites';

  @override
  Future<List<FavoriteModel>> getFavorites(String userId) async {
    final db = await _database.database;

    final result = await db.query(
      _table,
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'created_at DESC',
    );

    return result.map(FavoriteModel.fromMap).toList();
  }

  @override
  Future<bool> isFavorite(String userId, String favoriteId) async {
    final db = await _database.database;

    final result = await db.query(
      _table,
      columns: ['favorite_id'],
      where: '''
        user_id = ?
        AND favorite_id = ?
      ''',
      whereArgs: [userId, favoriteId],
      limit: 1,
    );

    return result.isNotEmpty;
  }

  @override
  Future<void> addFavorite(String userId, FavoriteModel favorite) async {
    final db = await _database.database;

    await db.insert(
      _table,
      favorite.toMap(userId: userId),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> removeFavorite(String userId, String favoriteId) async {
    final db = await _database.database;

    await db.delete(
      _table,
      where: '''
        user_id = ?
        AND favorite_id = ?
      ''',
      whereArgs: [userId, favoriteId],
    );
  }
}
