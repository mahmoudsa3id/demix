import 'package:demix/features/business/domain/entities/business.dart';
import 'package:demix/features/business/domain/entities/product.dart';
import 'package:demix/features/business/domain/entities/product_category.dart';

sealed class BusinessProfileState {
  const BusinessProfileState();
}

class BusinessProfileInitial extends BusinessProfileState {
  const BusinessProfileInitial();
}

class BusinessProfileLoading extends BusinessProfileState {
  const BusinessProfileLoading();
}

class BusinessProfileLoaded extends BusinessProfileState {
  const BusinessProfileLoaded({
    required this.business,
    required this.categories,
    required this.products,
  });

  final Business business;
  final List<ProductCategory> categories;
  final List<Product> products;
}

class BusinessProfileFailure extends BusinessProfileState {
  const BusinessProfileFailure(this.message);
  final String message;
}
