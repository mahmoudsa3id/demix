import 'package:demix/core/db/db.dart';
import 'package:sqflite/sqflite.dart';
import 'package:demix/features/business/domain/entities/business.dart';
import 'package:demix/features/business/domain/entities/working_hours.dart';
import 'package:demix/features/cart/data/models/cart_item_model.dart';
import 'package:demix/features/cart/domain/entities/cart_snapshot.dart';

abstract class CartLocalDataSource {
  Future<CartSnapshot> getSnapshot();
  Future<void> upsertItem(CartItemModel item, Business business);
  Future<void> deleteItem(String productId);
  Future<void> clear();
}

class SqfliteCartLocalDataSource implements CartLocalDataSource {
  SqfliteCartLocalDataSource({required this._database});
  final AppDatabase _database;

  Map<String, dynamic> _businessMap(Business b) => {
    'business_name': b.name,
    'business_type': b.type,
    'business_name_ar': b.nameAr,
    'business_name_en': b.nameEn,
    'business_cover_url': b.coverUrl,
    'business_logo_url': b.logoUrl,
    'business_address': b.address,
    'business_latitude': b.latitude,
    'business_longitude': b.longitude,
    'business_rating': b.rating,
    'business_review_count': b.reviewCount,
    'business_estimated_delivery_time': b.estimatedDeliveryTime,
    'business_delivery_fee': b.deliveryFee,
    'business_minimum_order': b.minimumOrder,
    'business_is_open': b.isOpen ? 1 : 0,
    'business_open': b.workingHours?.open,
    'business_close': b.workingHours?.close,
  };

  Business _businessFromMap(Map<String, dynamic> m, String id) => Business(
    id: id,
    name: m['business_name'] as String,
    type: m['business_type'] as String,
    nameAr: m['business_name_ar'] as String?,
    nameEn: m['business_name_en'] as String?,
    coverUrl: m['business_cover_url'] as String?,
    logoUrl: m['business_logo_url'] as String?,
    address: m['business_address'] as String?,
    latitude: (m['business_latitude'] as num?)?.toDouble(),
    longitude: (m['business_longitude'] as num?)?.toDouble(),
    rating: (m['business_rating'] as num? ?? 0).toDouble(),
    reviewCount: m['business_review_count'] as int? ?? 0,
    estimatedDeliveryTime: m['business_estimated_delivery_time'] as int? ?? 30,
    deliveryFee: (m['business_delivery_fee'] as num? ?? 0).toDouble(),
    minimumOrder: (m['business_minimum_order'] as num? ?? 0).toDouble(),
    isOpen: (m['business_is_open'] as int? ?? 1) == 1,
    workingHours: (m['business_open'] != null && m['business_close'] != null)
        ? WorkingHours(
            open: m['business_open'] as String,
            close: m['business_close'] as String,
          )
        : null,
  );

  @override
  Future<CartSnapshot> getSnapshot() async {
    final db = await _database.database;
    final rows = await db.query('cart_items', orderBy: 'created_at ASC');
    if (rows.isEmpty) return const CartSnapshot(items: []);
    final items = rows.map(CartItemModel.fromMap).toList();
    final first = rows.first;
    final business = _businessFromMap(first, first['business_id'] as String);
    return CartSnapshot(items: items, business: business);
  }

  @override
  Future<void> upsertItem(CartItemModel item, Business business) async {
    final db = await _database.database;
    final map = item.toMap(business: _businessMap(business));
    await db.insert(
      'cart_items',
      map,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> deleteItem(String productId) async {
    final db = await _database.database;
    await db.delete(
      'cart_items',
      where: 'product_id = ?',
      whereArgs: [productId],
    );
  }

  @override
  Future<void> clear() async {
    final db = await _database.database;
    await db.delete('cart_items');
  }
}
