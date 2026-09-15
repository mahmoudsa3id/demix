import 'package:cloud_firestore/cloud_firestore.dart';

class BusinessMockSeeder {
  BusinessMockSeeder({required FirebaseFirestore firestore})
    : _firestore = firestore;

  final FirebaseFirestore _firestore;

  Future<void> seedRestaurant() async {
    const businessId = 'burger_house';

    // =========================
    // BUSINESS
    // =========================

    await _firestore.collection('businesses').doc(businessId).set({
      'name': 'Sultan',
      'nameAr': 'برجر هاوس',
      'nameEn': 'Burger House',
      'type': 'restaurant',

      'coverUrl':
          'https://images.unsplash.com/photo-1568901346375-23c9450c58cd',

      'logoUrl': 'https://images.unsplash.com/photo-1571091718767-18b5b1457add',

      'address': 'Smouha, Alexandria',

      'latitude': 31.2156,
      'longitude': 29.9553,

      'rating': 4.8,
      'reviewCount': 320,

      'estimatedDeliveryTime': 35,
      'deliveryFee': 25,
      'minimumOrder': 100,

      'isOpen': true,

      'workingHours': {'open': '10:00', 'close': '02:00'},
    });

    // =========================
    // CATEGORIES
    // =========================

    await _seedCategories(businessId);

    // =========================
    // PRODUCTS
    // =========================

    await _seedProducts(businessId);
  }

  // ============================================================
  // CATEGORIES
  // ============================================================

  Future<void> _seedCategories(String businessId) async {
    final categories = [
      {
        'id': 'burgers',
        'name': 'Burgers',
        'nameEn': 'Burgers',
        'nameAr': 'برجر',
        'sortOrder': 1,
        'isActive': true,
      },
      {
        'id': 'meals',
        'name': 'Meals',
        'nameEn': 'Meals',
        'nameAr': 'وجبات',
        'sortOrder': 2,
        'isActive': true,
      },
      {
        'id': 'drinks',
        'name': 'Drinks',
        'nameEn': 'Drinks',
        'nameAr': 'مشروبات',
        'sortOrder': 3,
        'isActive': true,
      },
    ];

    for (final category in categories) {
      final categoryId = category['id'] as String;

      final data = Map<String, dynamic>.from(category)..remove('id');

      await _firestore
          .collection('businesses')
          .doc(businessId)
          .collection('categories')
          .doc(categoryId)
          .set(data);
    }
  }

  // ============================================================
  // PRODUCTS
  // ============================================================

  Future<void> _seedProducts(String businessId) async {
    // ----------------------------------------------------------
    // BURGERS
    // ----------------------------------------------------------

    await _product(
      businessId: businessId,
      id: 'classic_burger',
      categoryId: 'burgers',
      name: 'Classic Burger',
      nameAr: 'كلاسيك برجر',
      description: 'Beef burger with cheddar cheese, lettuce and tomato.',
      descriptionAr: 'برجر لحم مع جبنة شيدر وخس وطماطم.',
      price: 180,
      sortOrder: 1,
      imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd',
    );

    await _product(
      businessId: businessId,
      id: 'double_burger',
      categoryId: 'burgers',
      name: 'Double Burger',
      nameAr: 'دبل برجر',
      description: 'Double beef burger with cheddar cheese.',
      descriptionAr: 'برجر لحم دبل مع جبنة شيدر.',
      price: 240,
      sortOrder: 2,
      imageUrl: 'https://images.unsplash.com/photo-1550547660-d9450f859349',
    );

    await _product(
      businessId: businessId,
      id: 'chicken_burger',
      categoryId: 'burgers',
      name: 'Crispy Chicken Burger',
      nameAr: 'كريسبي تشيكن برجر',
      description: 'Crispy chicken burger with fresh vegetables.',
      descriptionAr: 'برجر تشيكن كريسبي مع خضروات طازجة.',
      price: 170,
      sortOrder: 3,
      imageUrl: 'https://images.unsplash.com/photo-1615297928064-24977384d0f8',
    );

    // ----------------------------------------------------------
    // MEALS
    // ----------------------------------------------------------

    await _product(
      businessId: businessId,
      id: 'chicken_meal',
      categoryId: 'meals',
      name: 'Chicken Meal',
      nameAr: 'وجبة تشيكن',
      description: 'Crispy chicken with fries and sauce.',
      descriptionAr: 'فراخ كريسبي مع بطاطس وصوص.',
      price: 220,
      sortOrder: 1,
      imageUrl: 'https://images.unsplash.com/photo-1562967916-eb82221dfb92',
    );

    await _product(
      businessId: businessId,
      id: 'burger_meal',
      categoryId: 'meals',
      name: 'Burger Meal',
      nameAr: 'وجبة برجر',
      description: 'Classic burger served with fries.',
      descriptionAr: 'برجر كلاسيك مع بطاطس.',
      price: 210,
      sortOrder: 2,
      imageUrl: 'https://images.unsplash.com/photo-1571091718767-18b5b1457add',
    );

    await _product(
      businessId: businessId,
      id: 'family_meal',
      categoryId: 'meals',
      name: 'Family Meal',
      nameAr: 'وجبة عائلية',
      description: 'A large meal for the whole family.',
      descriptionAr: 'وجبة كبيرة مناسبة للعائلة.',
      price: 450,
      sortOrder: 3,
      imageUrl: 'https://images.unsplash.com/photo-1600891964092-4316c288032e',
    );

    // ----------------------------------------------------------
    // DRINKS
    // ----------------------------------------------------------

    await _product(
      businessId: businessId,
      id: 'pepsi',
      categoryId: 'drinks',
      name: 'Pepsi',
      nameAr: 'بيبسي',
      description: 'Cold Pepsi.',
      descriptionAr: 'بيبسي ساقع.',
      price: 35,
      sortOrder: 1,
      imageUrl: 'https://images.unsplash.com/photo-1629203851122-3726ecdf080e',
    );

    await _product(
      businessId: businessId,
      id: 'cola',
      categoryId: 'drinks',
      name: 'Cola',
      nameAr: 'كولا',
      description: 'Cold cola.',
      descriptionAr: 'كولا ساقعة.',
      price: 35,
      sortOrder: 2,
      imageUrl: 'https://images.unsplash.com/photo-1581636625402-29b2a704ef13',
    );

    await _product(
      businessId: businessId,
      id: 'orange_juice',
      categoryId: 'drinks',
      name: 'Fresh Orange Juice',
      nameAr: 'عصير برتقال فريش',
      description: 'Freshly squeezed orange juice.',
      descriptionAr: 'عصير برتقال فريش.',
      price: 65,
      sortOrder: 3,
      imageUrl: 'https://images.unsplash.com/photo-1600271886742-f049cd451bba',
    );
  }

  // ============================================================
  // PRODUCT
  // ============================================================

  Future<void> _product({
    required String businessId,
    required String id,
    required String categoryId,
    required String name,
    required String nameAr,
    required String description,
    required String descriptionAr,
    required double price,
    required int sortOrder,
    required String imageUrl,
  }) async {
    await _firestore
        .collection('businesses')
        .doc(businessId)
        .collection('products')
        .doc(id)
        .set({
          'businessId': businessId,
          'categoryId': categoryId,

          'name': name,
          'nameEn': name,
          'nameAr': nameAr,

          'description': description,
          'descriptionEn': description,
          'descriptionAr': descriptionAr,

          'imageUrl': imageUrl,

          'price': price,

          'isAvailable': true,

          'sortOrder': sortOrder,
        });
  }
}
