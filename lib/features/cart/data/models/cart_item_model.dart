import 'package:demix/features/business/domain/entities/product.dart';
import 'package:demix/features/cart/domain/entities/cart_item.dart';

class CartItemModel extends CartItem {
  const CartItemModel({required super.product, required super.quantity});
  @override
  double get lineTotal => product.price * quantity;

  factory CartItemModel.fromMap(Map<String, dynamic> data) {
    return CartItemModel(
      product: Product(
        id: data['product_id'] as String,
        businessId: data['business_id'] as String,
        categoryId: data['category_id'] as String,
        name: data['product_name'] as String,
        nameAr: data['product_name_ar'] as String?,
        nameEn: data['product_name_en'] as String?,
        description: data['description'] as String?,
        descriptionAr: data['description_ar'] as String?,
        descriptionEn: data['description_en'] as String?,
        imageUrl: data['image_url'] as String?,
        price: (data['price'] as num).toDouble(),
        isAvailable: (data['is_available'] as int? ?? 1) == 1,
        sortOrder: data['sort_order'] as int? ?? 0,
        businessLogo: 'businessLogoUrl',
      ),
      quantity: data['quantity'] as int,
    );
  }

  Map<String, dynamic> toMap({
    required Map<String, dynamic> business,
    int? now,
  }) {
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
