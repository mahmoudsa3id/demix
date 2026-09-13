import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../models/location_model.dart';

class LocationLocalDataSource {
  static const _databaseName = 'demix_location.db';
  static const _databaseVersion = 1;
  static const table = 'saved_locations';

  Database? _database;

  Future<Database> get _db async {
    if (_database != null) return _database!;

    final root = await getDatabasesPath();
    final databasePath = join(root, _databaseName);

    _database = await openDatabase(
      databasePath,
      version: _databaseVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $table (
            id INTEGER PRIMARY KEY,
            latitude REAL NOT NULL,
            longitude REAL NOT NULL,
            country TEXT,
            city TEXT,
            area TEXT,
            street TEXT,
            formatted_address TEXT,
            zone_id TEXT,
            is_inside_zone INTEGER NOT NULL,
            created_at INTEGER,
            updated_at INTEGER
          )
        ''');
      },
    );

    return _database!;
  }

  Future<int> create(LocationModel model) async {
    final db = await _db;
    return db.insert(
      table,
      model.toSqlMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<LocationModel?> readCurrent() async {
    final db = await _db;
    final rows = await db.query(
      table,
      where: 'id = ?',
      whereArgs: [1],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return LocationModel.fromSqlMap(rows.first);
  }

  Future<int> update(LocationModel model) async {
    final db = await _db;
    return db.update(
      table,
      model.toSqlMap(),
      where: 'id = ?',
      whereArgs: [model.id],
    );
  }

  Future<int> deleteCurrent() async {
    final db = await _db;
    return db.delete(table, where: 'id = ?', whereArgs: [1]);
  }

  Future<void> close() async {
    await _database?.close();
    _database = null;
  }
}
