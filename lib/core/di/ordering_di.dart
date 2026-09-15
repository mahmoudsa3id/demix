import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';

import '../../core/db/db.dart';

import '../../features/cart/data/datasources/cart_local_data_source.dart';
import '../../features/cart/data/repositories/cart_repository_impl.dart';
import '../../features/cart/domain/repositories/cart_repository.dart';
import '../../features/cart/domain/use_cases/clear_cart_use_case.dart';
import '../../features/cart/domain/use_cases/delete_cart_item_use_case.dart';
import '../../features/cart/domain/use_cases/get_cart_use_case.dart';
import '../../features/cart/domain/use_cases/save_cart_item_use_case.dart';
import '../../features/cart/presentation/cubit/cart_cubit.dart';

import '../../features/orders/data/datasources/order_remote_data_source.dart';
import '../../features/orders/data/repositories/order_repository_impl.dart';
import '../../features/orders/domain/repositories/order_repository.dart';
import '../../features/orders/domain/use_cases/create_order_use_case.dart';
import '../../features/orders/domain/use_cases/watch_order_use_case.dart';
import '../../features/orders/presentation/cubit/order_cubit.dart';
import '../../features/orders/presentation/cubit/order_tracking_cubit.dart';

void setupOrderingDependencies(GetIt getIt) {
  // ─────────────────────────────────────────────
  // CART
  // ─────────────────────────────────────────────

  if (!getIt.isRegistered<CartLocalDataSource>()) {
    getIt.registerLazySingleton<CartLocalDataSource>(
      () => SqfliteCartLocalDataSource(database: getIt<AppDatabase>()),
    );
  }

  if (!getIt.isRegistered<CartRepository>()) {
    getIt.registerLazySingleton<CartRepository>(
      () => CartRepositoryImpl(localDataSource: getIt<CartLocalDataSource>()),
    );
  }

  if (!getIt.isRegistered<GetCartUseCase>()) {
    getIt.registerLazySingleton<GetCartUseCase>(
      () => GetCartUseCase(getIt<CartRepository>()),
    );
  }

  if (!getIt.isRegistered<SaveCartItemUseCase>()) {
    getIt.registerLazySingleton<SaveCartItemUseCase>(
      () => SaveCartItemUseCase(getIt<CartRepository>()),
    );
  }

  if (!getIt.isRegistered<DeleteCartItemUseCase>()) {
    getIt.registerLazySingleton<DeleteCartItemUseCase>(
      () => DeleteCartItemUseCase(getIt<CartRepository>()),
    );
  }

  if (!getIt.isRegistered<ClearCartUseCase>()) {
    getIt.registerLazySingleton<ClearCartUseCase>(
      () => ClearCartUseCase(getIt<CartRepository>()),
    );
  }

  if (!getIt.isRegistered<CartCubit>()) {
    getIt.registerLazySingleton<CartCubit>(
      () => CartCubit(
        getCart: getIt<GetCartUseCase>(),
        saveCartItem: getIt<SaveCartItemUseCase>(),
        deleteCartItem: getIt<DeleteCartItemUseCase>(),
        clearCart: getIt<ClearCartUseCase>(),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // ORDERS
  // ─────────────────────────────────────────────

  if (!getIt.isRegistered<OrderRemoteDataSource>()) {
    getIt.registerLazySingleton<OrderRemoteDataSource>(
      () => OrderRemoteDataSource(firestore: getIt<FirebaseFirestore>()),
    );
  }

  if (!getIt.isRegistered<OrderRepository>()) {
    getIt.registerLazySingleton<OrderRepository>(
      () => OrderRepositoryImpl(remote: getIt<OrderRemoteDataSource>()),
    );
  }

  if (!getIt.isRegistered<CreateOrderUseCase>()) {
    getIt.registerLazySingleton<CreateOrderUseCase>(
      () => CreateOrderUseCase(getIt<OrderRepository>()),
    );
  }

  if (!getIt.isRegistered<OrderCubit>()) {
    getIt.registerFactory<OrderCubit>(
      () => OrderCubit(createOrder: getIt<CreateOrderUseCase>()),
    );
  }

  if (!getIt.isRegistered<WatchOrderUseCase>()) {
    getIt.registerLazySingleton<WatchOrderUseCase>(
      () => WatchOrderUseCase(getIt<OrderRepository>()),
    );
  }

  if (!getIt.isRegistered<OrderTrackingCubit>()) {
    getIt.registerFactory<OrderTrackingCubit>(
      () => OrderTrackingCubit(watchOrder: getIt<WatchOrderUseCase>()),
    );
  }
}
