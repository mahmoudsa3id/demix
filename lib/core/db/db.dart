import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  AppDatabase();

  static const String _databaseName = 'demix.db';
  static const int _databaseVersion = 3;

  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    final root = await getDatabasesPath();
    final databasePath = join(root, _databaseName);

    _database = await openDatabase(
      databasePath,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );

    return _database!;
  }

  Future<void> _onCreate(Database db, int version) async {
    await _createSavedLocationsTable(db);
    await _createCartItemsTable(db);
    await _createFavoritesTable(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('DROP TABLE IF EXISTS cart_items');

      await _createCartItemsTable(db);
    }

    if (oldVersion < 3) {
      await _createFavoritesTable(db);
    }
  }

  Future<void> _createSavedLocationsTable(Database db) async {
    await db.execute('''
      CREATE TABLE saved_locations (
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
  }

  Future<void> _createCartItemsTable(Database db) async {
    await db.execute('''
      CREATE TABLE cart_items (
        product_id TEXT PRIMARY KEY,
        business_id TEXT NOT NULL,
        category_id TEXT,

        product_name TEXT NOT NULL,
        product_name_ar TEXT,
        product_name_en TEXT,

        description TEXT,
        description_ar TEXT,
        description_en TEXT,

        image_url TEXT,

        price REAL NOT NULL,
        is_available INTEGER NOT NULL,
        sort_order INTEGER NOT NULL,
        quantity INTEGER NOT NULL,

        created_at INTEGER,
        updated_at INTEGER,

        business_name TEXT,
        business_type TEXT,
        business_name_ar TEXT,
        business_name_en TEXT,

        business_cover_url TEXT,
        business_logo_url TEXT,
        business_address TEXT,

        business_latitude REAL,
        business_longitude REAL,

        business_rating REAL,
        business_review_count INTEGER,

        business_estimated_delivery_time INTEGER,
        business_delivery_fee REAL,
        business_minimum_order REAL,

        business_is_open INTEGER,

        business_open TEXT,
        business_close TEXT
      )
    ''');
  }

  Future<void> _createFavoritesTable(Database db) async {
    await db.execute('''
      CREATE TABLE favorites (
        favorite_id TEXT NOT NULL,
        user_id TEXT NOT NULL,

        type TEXT NOT NULL,
        item_id TEXT NOT NULL,

        name TEXT NOT NULL,
        name_ar TEXT,

        image_url TEXT,

        cover_url TEXT,
        logo_url TEXT,

        rating REAL,
        review_count INTEGER,

        price REAL,

        business_id TEXT,
        business_name TEXT,
        business_logo TEXT,
        business_rating REAL,

        created_at INTEGER NOT NULL,

        PRIMARY KEY (user_id, favorite_id),

        UNIQUE (user_id, type, item_id)
      )
    ''');

    await db.execute('''
      CREATE INDEX idx_favorites_user_id
      ON favorites(user_id)
    ''');

    await db.execute('''
      CREATE INDEX idx_favorites_type
      ON favorites(user_id, type)
    ''');
  }

  Future<void> close() async {
    await _database?.close();
    _database = null;
  }
}
