abstract class RoutePaths {
  // ================================================================
  // CUSTOMER / PUBLIC
  // ================================================================

  static const splash = '/';

  static const location = '/location';
  static const savedLocations = '/savedLocations';
  static const onboarding = '/onboarding';

  static const login = '/login';

  static const signup = '/signup';

  static const forgotPassword = '/forget-passowrd';

  static const otp = '/otp';

  static const completeProfile = '/complete-profile';

  static const home = '/home';

  static const search = '/search';

  // ================================================================
  // BUSINESS DISCOVERY
  // ================================================================

  static const category = '/category/:categoryId';

  static const categoryPath = '/category';

  static const restaurant = '/restaurant/:restaurantId';

  static const restaurantPath = '/restaurant';

  // ================================================================
  // PRODUCTS
  // ================================================================

  static const product = '/product/:productId';

  static const productPath = '/product';

  // ================================================================
  // CART & CHECKOUT
  // ================================================================

  static const cart = '/cart';

  static const checkout = '/checkout';

  static const checkoutLocation = '/checkout/location';

  static const addresses = '/addresses';

  static const addAddress = '/add-address';

  static const editAddress = '/edit-address';

  static const payment = '/payment';

  static const orderConfirmation = '/order-confirmation';

  // ================================================================
  // ORDERS
  // ================================================================

  static const orderSuccess = '/order-success/:orderId';

  static const orderSuccessPath = '/order-success';

  static const orders = '/orders';

  static const tracking = '/tracking';

  static const orderDetails = '/order-details';

  static const orderDetailsById = '/order-details/:orderId';

  // ================================================================
  // USER
  // ================================================================
  static const editProfile = '/editProfile';
  static const favorites = '/favorites';
  static const about = '/about';
  static const wallet = '/wallet';

  static const profile = '/profile';

  static const settings = '/settings';

  static const language = '/language';

  // ================================================================
  // INFORMATION
  // ================================================================

  static const notifications = '/notifications';

  static const privacy = '/privacy';

  static const terms = '/terms';

  static const offers = '/offers';

  static const support = '/support';

  // ================================================================
  // WORKSPACE SWITCHER
  // ================================================================

  static const workspace = '/workspace';

  // ================================================================
  // BUSINESS APP
  // Restaurant / Cafe Owner
  // ================================================================

  static const businessDashboard = '/business';

  static const businessOrders = '/business/orders';

  static const businessOrderDetails = '/business/orders/:orderId';

  static const businessMenu = '/business/menu';

  static const businessProductNew = '/business/menu/new';

  static const businessProductEdit = '/business/menu/:productId';

  static const businessOffers = '/business/offers';

  static const businessProfile = '/business/profile';

  static const businessAnalytics = '/business/analytics';

  // ================================================================
  // ADMIN APP
  // ================================================================

  static const adminDashboard = '/admin';

  static const adminUsers = '/admin/users';

  static const adminBusinesses = '/admin/businesses';

  static const adminBusinessDetails = '/admin/businesses/:businessId';

  static const adminCategories = '/admin/categories';

  static const adminOrders = '/admin/orders';

  static const adminCoupons = '/admin/coupons';

  static const adminSettings = '/admin/settings';

  // ================================================================
  // HELPERS
  // ================================================================

  static String categoryDetails(String categoryId) {
    return '$categoryPath/$categoryId';
  }

  static String restaurantDetails(String restaurantId) {
    return '$restaurantPath/$restaurantId';
  }

  static String productDetails(String productId) {
    return '$productPath/$productId';
  }

  static String orderDetailsFor(String orderId) {
    return '$orderDetails/$orderId';
  }

  static String orderSuccessFor(String orderId) {
    return '$orderSuccessPath/$orderId';
  }

  static String businessOrderDetailsFor(String orderId) {
    return '$businessOrders/$orderId';
  }

  static String businessProductEditFor(String productId) {
    return '$businessMenu/$productId';
  }

  static String adminBusinessDetailsFor(String businessId) {
    return '$adminBusinesses/$businessId';
  }
}
