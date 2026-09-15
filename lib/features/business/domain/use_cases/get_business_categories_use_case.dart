import 'package:demix/features/business/domain/entities/product_category.dart';
import 'package:demix/features/business/domain/repositories/business_repository.dart';

class GetBusinessCategoriesUseCase {
  const GetBusinessCategoriesUseCase(this._repository);
  final BusinessRepository _repository;
  Future<List<ProductCategory>> call(String businessId) => _repository.getCategories(businessId);
}
