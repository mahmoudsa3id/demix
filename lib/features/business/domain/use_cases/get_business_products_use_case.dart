import 'package:demix/features/business/domain/entities/product.dart';
import 'package:demix/features/business/domain/repositories/business_repository.dart';

class GetBusinessProductsUseCase {
  const GetBusinessProductsUseCase(this._repository);
  final BusinessRepository _repository;
  Future<List<Product>> call(String businessId, {String? categoryId}) =>
      _repository.getProducts(businessId, categoryId: categoryId);
}
