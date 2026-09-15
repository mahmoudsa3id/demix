import 'package:demix/core/db/db.dart';
import 'package:sqflite/sqflite.dart';
import '../../models/location_model.dart';

class LocationLocalDataSource {
  LocationLocalDataSource({required this._database});

  final AppDatabase _database;

  Future<Database> get _db => _database.database;

  Future<int> create(LocationModel model) async {
    final db = await _db;

    return db.insert(
      'saved_locations',
      model.toSqlMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<LocationModel?> readCurrent() async {
    final db = await _db;

    final rows = await db.query(
      'saved_locations',
      where: 'id = ?',
      whereArgs: [1],
      limit: 1,
    );

    if (rows.isEmpty) {
      return null;
    }

    return LocationModel.fromSqlMap(rows.first);
  }

  Future<int> update(LocationModel model) async {
    final db = await _db;

    return db.update(
      'saved_locations',
      model.toSqlMap(),
      where: 'id = ?',
      whereArgs: [model.id],
    );
  }

  Future<int> deleteCurrent() async {
    final db = await _db;

    return db.delete('saved_locations', where: 'id = ?', whereArgs: [1]);
  }
}
