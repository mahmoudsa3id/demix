import 'package:demix/features/business/domain/entities/product.dart';
import 'package:demix/features/cart/domain/entities/cart_item.dart';

class CartItemModel extends CartItem {
  const CartItemModel({required super.product, required super.quantity});

  factory CartItemModel.fromMap(Map<String, dynamic> map) {
    return CartItemModel(
      product: Product(
        id: map['product_id'] as String,
        businessId: map['business_id'] as String,
        categoryId: map['category_id'] as String,
        name: map['product_name'] as String,
        nameAr: map['product_name_ar'] as String?,
        nameEn: map['product_name_en'] as String?,
        description: map['description'] as String?,
        descriptionAr: map['description_ar'] as String?,
        descriptionEn: map['description_en'] as String?,
        imageUrl: map['image_url'] as String?,
        price: (map['price'] as num).toDouble(),
        isAvailable: (map['is_available'] as int? ?? 1) == 1,
        sortOrder: map['sort_order'] as int? ?? 0,
      ),
      quantity: map['quantity'] as int,
    );
  }

  Map<String, dynamic> toMap({required Map<String, dynamic> business, int? now}) {
    final timestamp = now ?? DateTime.now().millisecondsSinceEpoch;
    return {
      'product_id': product.id,
      'business_id': product.businessId,
      'category_id': product.categoryId,
      'product_name': product.name,
      'product_name_ar': product.nameAr,
      'product_name_en': product.nameEn,
      'description': product.description,
      'description_ar': product.descriptionAr,
      'description_en': product.descriptionEn,
      'image_url': product.imageUrl,
      'price': product.price,
      'is_available': product.isAvailable ? 1 : 0,
      'sort_order': product.sortOrder,
      'quantity': quantity,
      'created_at': timestamp,
      'updated_at': timestamp,
      ...business,
    };
  }
}
