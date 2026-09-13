abstract class RoutePaths {
  static const splash = '/';
  static const location = '/location';
  static const onboarding = '/onboarding';
  static const forgotPassword = '/forget-passowrd';
  static const signup = '/signup';
  static const home = '/home';
  static const search = '/search';
  static const category = '/category/:categoryId';
  static const restaurant = '/restaurant/:restaurantId';
  static const restaurantPath = '/restaurant';
  static const product = '/product/:productId';
  static const productPath = '/product';
  static const cart = '/cart';
  static const checkout = '/checkout';
  static const login = '/login';
  static const otp = '/otp';
  static const completeProfile = '/complete-profile';
  static const addresses = '/addresses';
  static const addAddress = '/add-address';
  static const editAddress = '/edit-address';
  static const payment = '/payment';
  static const orderConfirmation = '/order-confirmation';
  static const tracking = '/tracking';
  static const orderDetails = '/order-details';
  static const orderDetailsById = '/order-details/:orderId';
  static const favorites = '/favorites';
  static const wallet = '/wallet';
  static const profile = '/profile';
  static const settings = '/settings';
  static const language = '/language';
  static const orders = '/orders';
  static const support = '/support';
  static const notifications = '/notifications';
  static const privacy = '/privacy';
  static const terms = '/terms';
  static const offers = '/offers';

  // ================================================================
  // WORKSPACE SWITCHER (users with more than one privileged role)
  // ================================================================
  static const workspace = '/workspace';

  // ================================================================
  // BUSINESS APP (restaurant / cafe owner)
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

  static String businessOrderDetailsFor(String orderId) =>
      '/business/orders/$orderId';
  static String businessProductEditFor(String productId) =>
      '/business/menu/$productId';

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

  static String adminBusinessDetailsFor(String businessId) =>
      '/admin/businesses/$businessId';

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
    return '$orderDetailsPath/$orderId';
  }

  static const categoryPath = '/category';
  static const orderDetailsPath = '/order-details';
}
