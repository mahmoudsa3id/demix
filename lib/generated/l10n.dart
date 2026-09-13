// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Search for a restaurant or meal`
  String get searchHint {
    return Intl.message(
      'Search for a restaurant or meal',
      name: 'searchHint',
      desc: '',
      args: [],
    );
  }

  /// `Delivery to`
  String get deliveryTo {
    return Intl.message('Delivery to', name: 'deliveryTo', desc: '', args: []);
  }

  /// `See all`
  String get seeAll {
    return Intl.message('See all', name: 'seeAll', desc: '', args: []);
  }

  /// `Nearby restaurants`
  String get nearbyRestaurants {
    return Intl.message(
      'Nearby restaurants',
      name: 'nearbyRestaurants',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message('Home', name: 'home', desc: '', args: []);
  }

  /// `Search`
  String get search {
    return Intl.message('Search', name: 'search', desc: '', args: []);
  }

  /// `Orders`
  String get orders {
    return Intl.message('Orders', name: 'orders', desc: '', args: []);
  }

  /// `Favorites`
  String get favorites {
    return Intl.message('Favorites', name: 'favorites', desc: '', args: []);
  }

  /// `Cart`
  String get cart {
    return Intl.message('Cart', name: 'cart', desc: '', args: []);
  }

  /// `Wallet`
  String get wallet {
    return Intl.message('Wallet', name: 'wallet', desc: '', args: []);
  }

  /// `Search`
  String get searchTitle {
    return Intl.message('Search', name: 'searchTitle', desc: '', args: []);
  }

  /// `Searching...`
  String get searching {
    return Intl.message('Searching...', name: 'searching', desc: '', args: []);
  }

  /// `No results found`
  String get noResults {
    return Intl.message(
      'No results found',
      name: 'noResults',
      desc: '',
      args: [],
    );
  }

  /// `Search your favorite restaurant`
  String get searchPlaceholder {
    return Intl.message(
      'Search your favorite restaurant',
      name: 'searchPlaceholder',
      desc: '',
      args: [],
    );
  }

  /// `Cart is empty`
  String get cartEmpty {
    return Intl.message('Cart is empty', name: 'cartEmpty', desc: '', args: []);
  }

  /// `Add some of your favorite dishes`
  String get cartEmptyDescription {
    return Intl.message(
      'Add some of your favorite dishes',
      name: 'cartEmptyDescription',
      desc: '',
      args: [],
    );
  }

  /// `Add to Cart`
  String get addToCart {
    return Intl.message('Add to Cart', name: 'addToCart', desc: '', args: []);
  }

  /// `Added to Cart`
  String get addedToCart {
    return Intl.message(
      'Added to Cart',
      name: 'addedToCart',
      desc: '',
      args: [],
    );
  }

  /// `Checkout`
  String get checkout {
    return Intl.message('Checkout', name: 'checkout', desc: '', args: []);
  }

  /// `Subtotal`
  String get subtotal {
    return Intl.message('Subtotal', name: 'subtotal', desc: '', args: []);
  }

  /// `Delivery Fee`
  String get deliveryFee {
    return Intl.message(
      'Delivery Fee',
      name: 'deliveryFee',
      desc: '',
      args: [],
    );
  }

  /// `Discount`
  String get discount {
    return Intl.message('Discount', name: 'discount', desc: '', args: []);
  }

  /// `Total`
  String get total {
    return Intl.message('Total', name: 'total', desc: '', args: []);
  }

  /// `Do you have a coupon?`
  String get coupon {
    return Intl.message(
      'Do you have a coupon?',
      name: 'coupon',
      desc: '',
      args: [],
    );
  }

  /// `Apply`
  String get applyCoupon {
    return Intl.message('Apply', name: 'applyCoupon', desc: '', args: []);
  }

  /// `Enter coupon code`
  String get couponPlaceholder {
    return Intl.message(
      'Enter coupon code',
      name: 'couponPlaceholder',
      desc: '',
      args: [],
    );
  }

  /// `Current Orders`
  String get currentOrders {
    return Intl.message(
      'Current Orders',
      name: 'currentOrders',
      desc: '',
      args: [],
    );
  }

  /// `Previous Orders`
  String get previousOrders {
    return Intl.message(
      'Previous Orders',
      name: 'previousOrders',
      desc: '',
      args: [],
    );
  }

  /// `No current orders`
  String get noCurrentOrders {
    return Intl.message(
      'No current orders',
      name: 'noCurrentOrders',
      desc: '',
      args: [],
    );
  }

  /// `No previous orders`
  String get noPreviousOrders {
    return Intl.message(
      'No previous orders',
      name: 'noPreviousOrders',
      desc: '',
      args: [],
    );
  }

  /// `Details`
  String get orderDetails {
    return Intl.message('Details', name: 'orderDetails', desc: '', args: []);
  }

  /// `Reorder`
  String get reorder {
    return Intl.message('Reorder', name: 'reorder', desc: '', args: []);
  }

  /// `Pending`
  String get orderStatusPending {
    return Intl.message(
      'Pending',
      name: 'orderStatusPending',
      desc: '',
      args: [],
    );
  }

  /// `Accepted`
  String get orderStatusAccepted {
    return Intl.message(
      'Accepted',
      name: 'orderStatusAccepted',
      desc: '',
      args: [],
    );
  }

  /// `Preparing`
  String get orderStatusPreparing {
    return Intl.message(
      'Preparing',
      name: 'orderStatusPreparing',
      desc: '',
      args: [],
    );
  }

  /// `Ready`
  String get orderStatusReady {
    return Intl.message('Ready', name: 'orderStatusReady', desc: '', args: []);
  }

  /// `Driver Assigned`
  String get orderStatusDriverAssigned {
    return Intl.message(
      'Driver Assigned',
      name: 'orderStatusDriverAssigned',
      desc: '',
      args: [],
    );
  }

  /// `Picked Up`
  String get orderStatusPickedUp {
    return Intl.message(
      'Picked Up',
      name: 'orderStatusPickedUp',
      desc: '',
      args: [],
    );
  }

  /// `On The Way`
  String get orderStatusOnTheWay {
    return Intl.message(
      'On The Way',
      name: 'orderStatusOnTheWay',
      desc: '',
      args: [],
    );
  }

  /// `Delivered`
  String get orderStatusDelivered {
    return Intl.message(
      'Delivered',
      name: 'orderStatusDelivered',
      desc: '',
      args: [],
    );
  }

  /// `Cancelled`
  String get orderStatusCancelled {
    return Intl.message(
      'Cancelled',
      name: 'orderStatusCancelled',
      desc: '',
      args: [],
    );
  }

  /// `My Account`
  String get profile {
    return Intl.message('My Account', name: 'profile', desc: '', args: []);
  }

  /// `Total Orders`
  String get totalOrders {
    return Intl.message(
      'Total Orders',
      name: 'totalOrders',
      desc: '',
      args: [],
    );
  }

  /// `My Favorites`
  String get myFavorites {
    return Intl.message(
      'My Favorites',
      name: 'myFavorites',
      desc: '',
      args: [],
    );
  }

  /// `My Addresses`
  String get myAddresses {
    return Intl.message(
      'My Addresses',
      name: 'myAddresses',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message('Settings', name: 'settings', desc: '', args: []);
  }

  /// `Language`
  String get language {
    return Intl.message('Language', name: 'language', desc: '', args: []);
  }

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `Privacy`
  String get privacy {
    return Intl.message('Privacy', name: 'privacy', desc: '', args: []);
  }

  /// `Terms & Conditions`
  String get terms {
    return Intl.message(
      'Terms & Conditions',
      name: 'terms',
      desc: '',
      args: [],
    );
  }

  /// `Support`
  String get support {
    return Intl.message('Support', name: 'support', desc: '', args: []);
  }

  /// `FAQ`
  String get faq {
    return Intl.message('FAQ', name: 'faq', desc: '', args: []);
  }

  /// `Contact Us`
  String get contactUs {
    return Intl.message('Contact Us', name: 'contactUs', desc: '', args: []);
  }

  /// `About`
  String get about {
    return Intl.message('About', name: 'about', desc: '', args: []);
  }

  /// `Logout`
  String get logout {
    return Intl.message('Logout', name: 'logout', desc: '', args: []);
  }

  /// `No favorites`
  String get noFavorites {
    return Intl.message(
      'No favorites',
      name: 'noFavorites',
      desc: '',
      args: [],
    );
  }

  /// `Add your favorite restaurants and cafes here`
  String get noFavoritesDescription {
    return Intl.message(
      'Add your favorite restaurants and cafes here',
      name: 'noFavoritesDescription',
      desc: '',
      args: [],
    );
  }

  /// `Wallet Balance`
  String get walletBalance {
    return Intl.message(
      'Wallet Balance',
      name: 'walletBalance',
      desc: '',
      args: [],
    );
  }

  /// `Transactions`
  String get transactions {
    return Intl.message(
      'Transactions',
      name: 'transactions',
      desc: '',
      args: [],
    );
  }

  /// `Recharge`
  String get recharge {
    return Intl.message('Recharge', name: 'recharge', desc: '', args: []);
  }

  /// `Transfer`
  String get transfer {
    return Intl.message('Transfer', name: 'transfer', desc: '', args: []);
  }

  /// `No transactions`
  String get noTransactions {
    return Intl.message(
      'No transactions',
      name: 'noTransactions',
      desc: '',
      args: [],
    );
  }

  /// `Credit`
  String get credit {
    return Intl.message('Credit', name: 'credit', desc: '', args: []);
  }

  /// `Debit`
  String get debit {
    return Intl.message('Debit', name: 'debit', desc: '', args: []);
  }

  /// `Refund`
  String get refund {
    return Intl.message('Refund', name: 'refund', desc: '', args: []);
  }

  /// `Checkout`
  String get checkoutTitle {
    return Intl.message('Checkout', name: 'checkoutTitle', desc: '', args: []);
  }

  /// `Delivery Method`
  String get deliveryMethod {
    return Intl.message(
      'Delivery Method',
      name: 'deliveryMethod',
      desc: '',
      args: [],
    );
  }

  /// `Delivery`
  String get delivery {
    return Intl.message('Delivery', name: 'delivery', desc: '', args: []);
  }

  /// `Pickup from Store`
  String get pickup {
    return Intl.message(
      'Pickup from Store',
      name: 'pickup',
      desc: '',
      args: [],
    );
  }

  /// `Delivery Address`
  String get deliveryAddress {
    return Intl.message(
      'Delivery Address',
      name: 'deliveryAddress',
      desc: '',
      args: [],
    );
  }

  /// `Special Instructions`
  String get specialInstructions {
    return Intl.message(
      'Special Instructions',
      name: 'specialInstructions',
      desc: '',
      args: [],
    );
  }

  /// `Add any special instructions...`
  String get specialInstructionsPlaceholder {
    return Intl.message(
      'Add any special instructions...',
      name: 'specialInstructionsPlaceholder',
      desc: '',
      args: [],
    );
  }

  /// `Order Summary`
  String get orderSummary {
    return Intl.message(
      'Order Summary',
      name: 'orderSummary',
      desc: '',
      args: [],
    );
  }

  /// `Payment Method`
  String get paymentMethod {
    return Intl.message(
      'Payment Method',
      name: 'paymentMethod',
      desc: '',
      args: [],
    );
  }

  /// `Credit Card`
  String get creditCard {
    return Intl.message('Credit Card', name: 'creditCard', desc: '', args: []);
  }

  /// `Cash on Delivery`
  String get cash {
    return Intl.message('Cash on Delivery', name: 'cash', desc: '', args: []);
  }

  /// `Confirm Order`
  String get confirmOrder {
    return Intl.message(
      'Confirm Order',
      name: 'confirmOrder',
      desc: '',
      args: [],
    );
  }

  /// `({count} reviews)`
  String ratingStars(Object count) {
    return Intl.message(
      '($count reviews)',
      name: 'ratingStars',
      desc: '',
      args: [count],
    );
  }

  /// `{time} min`
  String deliveryTime(Object time) {
    return Intl.message(
      '$time min',
      name: 'deliveryTime',
      desc: '',
      args: [time],
    );
  }

  /// `Free`
  String get freeDelivery {
    return Intl.message('Free', name: 'freeDelivery', desc: '', args: []);
  }

  /// `No Internet`
  String get noInternet {
    return Intl.message('No Internet', name: 'noInternet', desc: '', args: []);
  }

  /// `Please check your internet connection`
  String get noInternetDescription {
    return Intl.message(
      'Please check your internet connection',
      name: 'noInternetDescription',
      desc: '',
      args: [],
    );
  }

  /// `Retry`
  String get retry {
    return Intl.message('Retry', name: 'retry', desc: '', args: []);
  }

  /// `Error`
  String get error {
    return Intl.message('Error', name: 'error', desc: '', args: []);
  }

  /// `Something went wrong`
  String get errorDescription {
    return Intl.message(
      'Something went wrong',
      name: 'errorDescription',
      desc: '',
      args: [],
    );
  }

  /// `Good food`
  String get heroTitle {
    return Intl.message('Good food', name: 'heroTitle', desc: '', args: []);
  }

  /// `Good mood`
  String get heroSubtitle {
    return Intl.message('Good mood', name: 'heroSubtitle', desc: '', args: []);
  }

  /// `Discover delicious food from the best places around you`
  String get heroDescription {
    return Intl.message(
      'Discover delicious food from the best places around you',
      name: 'heroDescription',
      desc: '',
      args: [],
    );
  }

  /// `Restaurants`
  String get restaurants {
    return Intl.message('Restaurants', name: 'restaurants', desc: '', args: []);
  }

  /// `Discover the best restaurants around you`
  String get restaurantsDescription {
    return Intl.message(
      'Discover the best restaurants around you',
      name: 'restaurantsDescription',
      desc: '',
      args: [],
    );
  }

  /// `Cafes`
  String get cafes {
    return Intl.message('Cafes', name: 'cafes', desc: '', args: []);
  }

  /// `Enjoy your favorite coffee and drinks`
  String get cafesDescription {
    return Intl.message(
      'Enjoy your favorite coffee and drinks',
      name: 'cafesDescription',
      desc: '',
      args: [],
    );
  }

  /// `Special Offer`
  String get specialOffer {
    return Intl.message(
      'Special Offer',
      name: 'specialOffer',
      desc: '',
      args: [],
    );
  }

  /// `Up to`
  String get discountPrefix {
    return Intl.message('Up to', name: 'discountPrefix', desc: '', args: []);
  }

  /// `OFF`
  String get discountSuffix {
    return Intl.message('OFF', name: 'discountSuffix', desc: '', args: []);
  }

  /// `Enjoy special offers from your favorite places`
  String get offerDescription {
    return Intl.message(
      'Enjoy special offers from your favorite places',
      name: 'offerDescription',
      desc: '',
      args: [],
    );
  }

  /// `Order Now`
  String get orderNow {
    return Intl.message('Order Now', name: 'orderNow', desc: '', args: []);
  }

  /// `Popular Near You`
  String get popularNearYou {
    return Intl.message(
      'Popular Near You',
      name: 'popularNearYou',
      desc: '',
      args: [],
    );
  }

  /// `Recommended For You`
  String get recommendedForYou {
    return Intl.message(
      'Recommended For You',
      name: 'recommendedForYou',
      desc: '',
      args: [],
    );
  }

  /// `More Restaurants`
  String get moreRestaurants {
    return Intl.message(
      'More Restaurants',
      name: 'moreRestaurants',
      desc: '',
      args: [],
    );
  }

  /// `View More`
  String get viewMore {
    return Intl.message('View More', name: 'viewMore', desc: '', args: []);
  }

  /// `Rating`
  String get rating {
    return Intl.message('Rating', name: 'rating', desc: '', args: []);
  }

  /// `Reviews`
  String get reviews {
    return Intl.message('Reviews', name: 'reviews', desc: '', args: []);
  }

  /// `min`
  String get minutes {
    return Intl.message('min', name: 'minutes', desc: '', args: []);
  }

  /// `Favorite`
  String get favorite {
    return Intl.message('Favorite', name: 'favorite', desc: '', args: []);
  }

  /// `Remove from Favorites`
  String get removeFavorite {
    return Intl.message(
      'Remove from Favorites',
      name: 'removeFavorite',
      desc: '',
      args: [],
    );
  }

  /// `EGP`
  String get currency {
    return Intl.message('EGP', name: 'currency', desc: '', args: []);
  }

  /// `Need help?`
  String get loginNeedHelp {
    return Intl.message(
      'Need help?',
      name: 'loginNeedHelp',
      desc: '',
      args: [],
    );
  }

  /// `A  T A S T I E R  Y O U`
  String get loginTagline {
    return Intl.message(
      'A  T A S T I E R  Y O U',
      name: 'loginTagline',
      desc: '',
      args: [],
    );
  }

  /// `Login Successfuly`
  String get loginSuccess {
    return Intl.message(
      'Login Successfuly',
      name: 'loginSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Welcome`
  String get loginWelcome {
    return Intl.message('Welcome', name: 'loginWelcome', desc: '', args: []);
  }

  /// `Skip`
  String get onboardingSkip {
    return Intl.message('Skip', name: 'onboardingSkip', desc: '', args: []);
  }

  /// `Continue`
  String get onboardingContinue {
    return Intl.message(
      'Continue',
      name: 'onboardingContinue',
      desc: '',
      args: [],
    );
  }

  /// `Get Started`
  String get onboardingGetStarted {
    return Intl.message(
      'Get Started',
      name: 'onboardingGetStarted',
      desc: '',
      args: [],
    );
  }

  /// `Choose your preferred language`
  String get onboardingChooseLanguage {
    return Intl.message(
      'Choose your preferred language',
      name: 'onboardingChooseLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Made for your cravings.`
  String get onboardingFoodTitle {
    return Intl.message(
      'Made for your cravings.',
      name: 'onboardingFoodTitle',
      desc: '',
      args: [],
    );
  }

  /// `Big flavors. Zero compromises.`
  String get onboardingFoodDescription {
    return Intl.message(
      'Big flavors. Zero compromises.',
      name: 'onboardingFoodDescription',
      desc: '',
      args: [],
    );
  }

  /// `Sip your mood.`
  String get onboardingDrinksTitle {
    return Intl.message(
      'Sip your mood.',
      name: 'onboardingDrinksTitle',
      desc: '',
      args: [],
    );
  }

  /// `Something refreshing is always a good idea.`
  String get onboardingDrinksDescription {
    return Intl.message(
      'Something refreshing is always a good idea.',
      name: 'onboardingDrinksDescription',
      desc: '',
      args: [],
    );
  }

  /// `On the way to you.`
  String get onboardingDeliveryTitle {
    return Intl.message(
      'On the way to you.',
      name: 'onboardingDeliveryTitle',
      desc: '',
      args: [],
    );
  }

  /// `Hot. Fresh. Right on time.`
  String get onboardingDeliveryDescription {
    return Intl.message(
      'Hot. Fresh. Right on time.',
      name: 'onboardingDeliveryDescription',
      desc: '',
      args: [],
    );
  }

  /// `Back`
  String get loginBack {
    return Intl.message('Back', name: 'loginBack', desc: '', args: []);
  }

  /// `Sign in to continue your delicious journey.`
  String get loginDescription {
    return Intl.message(
      'Sign in to continue your delicious journey.',
      name: 'loginDescription',
      desc: '',
      args: [],
    );
  }

  /// `Email or Phone Number`
  String get loginEmailOrPhone {
    return Intl.message(
      'Email or Phone Number',
      name: 'loginEmailOrPhone',
      desc: '',
      args: [],
    );
  }

  /// `Email is required`
  String get loginEmailRequired {
    return Intl.message(
      'Email is required',
      name: 'loginEmailRequired',
      desc: '',
      args: [],
    );
  }

  /// `Enter a valid email`
  String get loginInvalidEmail {
    return Intl.message(
      'Enter a valid email',
      name: 'loginInvalidEmail',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get loginPassword {
    return Intl.message('Password', name: 'loginPassword', desc: '', args: []);
  }

  /// `Password is required`
  String get loginPasswordRequired {
    return Intl.message(
      'Password is required',
      name: 'loginPasswordRequired',
      desc: '',
      args: [],
    );
  }

  /// `Password must not contain spaces`
  String get loginPasswordNoSpaces {
    return Intl.message(
      'Password must not contain spaces',
      name: 'loginPasswordNoSpaces',
      desc: '',
      args: [],
    );
  }

  /// `Password must be at least 8 characters`
  String get loginPasswordMinLength {
    return Intl.message(
      'Password must be at least 8 characters',
      name: 'loginPasswordMinLength',
      desc: '',
      args: [],
    );
  }

  /// `Add at least one uppercase letter`
  String get loginPasswordUppercase {
    return Intl.message(
      'Add at least one uppercase letter',
      name: 'loginPasswordUppercase',
      desc: '',
      args: [],
    );
  }

  /// `Add at least one lowercase letter`
  String get loginPasswordLowercase {
    return Intl.message(
      'Add at least one lowercase letter',
      name: 'loginPasswordLowercase',
      desc: '',
      args: [],
    );
  }

  /// `Add at least one number`
  String get loginPasswordNumber {
    return Intl.message(
      'Add at least one number',
      name: 'loginPasswordNumber',
      desc: '',
      args: [],
    );
  }

  /// `Add at least one special character`
  String get loginPasswordSpecial {
    return Intl.message(
      'Add at least one special character',
      name: 'loginPasswordSpecial',
      desc: '',
      args: [],
    );
  }

  /// `This password is too common`
  String get loginPasswordCommon {
    return Intl.message(
      'This password is too common',
      name: 'loginPasswordCommon',
      desc: '',
      args: [],
    );
  }

  /// `Forgot Password?`
  String get loginForgotPassword {
    return Intl.message(
      'Forgot Password?',
      name: 'loginForgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `Sign In`
  String get loginSignIn {
    return Intl.message('Sign In', name: 'loginSignIn', desc: '', args: []);
  }

  /// `or continue with`
  String get loginOrContinueWith {
    return Intl.message(
      'or continue with',
      name: 'loginOrContinueWith',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an account?`
  String get loginNoAccount {
    return Intl.message(
      'Don\'t have an account?',
      name: 'loginNoAccount',
      desc: '',
      args: [],
    );
  }

  /// `Create Account`
  String get loginCreateAccount {
    return Intl.message(
      'Create Account',
      name: 'loginCreateAccount',
      desc: '',
      args: [],
    );
  }

  /// `Good`
  String get loginGood {
    return Intl.message('Good', name: 'loginGood', desc: '', args: []);
  }

  /// `Food`
  String get loginFood {
    return Intl.message('Food', name: 'loginFood', desc: '', args: []);
  }

  /// `Mood`
  String get loginMood {
    return Intl.message('Mood', name: 'loginMood', desc: '', args: []);
  }

  /// `REAL FOOD`
  String get loginRealFood {
    return Intl.message('REAL FOOD', name: 'loginRealFood', desc: '', args: []);
  }

  /// `REAL PEOPLE`
  String get loginRealPeople {
    return Intl.message(
      'REAL PEOPLE',
      name: 'loginRealPeople',
      desc: '',
      args: [],
    );
  }

  /// `HAPPIER DAYS`
  String get loginHappierDays {
    return Intl.message(
      'HAPPIER DAYS',
      name: 'loginHappierDays',
      desc: '',
      args: [],
    );
  }

  /// `Create`
  String get signupCreate {
    return Intl.message('Create', name: 'signupCreate', desc: '', args: []);
  }

  /// `Account`
  String get signupAccount {
    return Intl.message('Account', name: 'signupAccount', desc: '', args: []);
  }

  /// `Forgot`
  String get forgotPasswordTitle {
    return Intl.message(
      'Forgot',
      name: 'forgotPasswordTitle',
      desc: '',
      args: [],
    );
  }

  /// `Password?`
  String get forgotPasswordHighlight {
    return Intl.message(
      'Password?',
      name: 'forgotPasswordHighlight',
      desc: '',
      args: [],
    );
  }

  /// `Enter your email and we'll send you a link to reset your password.`
  String get forgotPasswordDescription {
    return Intl.message(
      'Enter your email and we\'ll send you a link to reset your password.',
      name: 'forgotPasswordDescription',
      desc: '',
      args: [],
    );
  }

  /// `Send Reset Link`
  String get forgotPasswordSend {
    return Intl.message(
      'Send Reset Link',
      name: 'forgotPasswordSend',
      desc: '',
      args: [],
    );
  }

  /// `Back to Sign In`
  String get forgotPasswordBackToLogin {
    return Intl.message(
      'Back to Sign In',
      name: 'forgotPasswordBackToLogin',
      desc: '',
      args: [],
    );
  }

  /// `Password reset link sent successfully`
  String get forgotPasswordSuccess {
    return Intl.message(
      'Password reset link sent successfully',
      name: 'forgotPasswordSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Create your account and start your delicious journey.`
  String get signupDescription {
    return Intl.message(
      'Create your account and start your delicious journey.',
      name: 'signupDescription',
      desc: '',
      args: [],
    );
  }

  /// `Full Name`
  String get signupName {
    return Intl.message('Full Name', name: 'signupName', desc: '', args: []);
  }

  /// `Name is required`
  String get signupNameRequired {
    return Intl.message(
      'Name is required',
      name: 'signupNameRequired',
      desc: '',
      args: [],
    );
  }

  /// `Enter a valid name`
  String get signupNameInvalid {
    return Intl.message(
      'Enter a valid name',
      name: 'signupNameInvalid',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get signupConfirmPassword {
    return Intl.message(
      'Confirm Password',
      name: 'signupConfirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Please confirm your password`
  String get signupConfirmPasswordRequired {
    return Intl.message(
      'Please confirm your password',
      name: 'signupConfirmPasswordRequired',
      desc: '',
      args: [],
    );
  }

  /// `Passwords do not match`
  String get signupPasswordsDoNotMatch {
    return Intl.message(
      'Passwords do not match',
      name: 'signupPasswordsDoNotMatch',
      desc: '',
      args: [],
    );
  }

  /// `Passwords match`
  String get signupPasswordsMatch {
    return Intl.message(
      'Passwords match',
      name: 'signupPasswordsMatch',
      desc: '',
      args: [],
    );
  }

  /// `Create Account`
  String get signupCreateAccount {
    return Intl.message(
      'Create Account',
      name: 'signupCreateAccount',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account?`
  String get signupAlreadyHaveAccount {
    return Intl.message(
      'Already have an account?',
      name: 'signupAlreadyHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Sign In`
  String get signupLogin {
    return Intl.message('Sign In', name: 'signupLogin', desc: '', args: []);
  }

  /// `Account created successfully`
  String get signupSuccess {
    return Intl.message(
      'Account created successfully',
      name: 'signupSuccess',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
