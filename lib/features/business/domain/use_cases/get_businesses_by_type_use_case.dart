import 'package:demix/features/business/domain/entities/business.dart';
import 'package:demix/features/business/domain/repositories/business_repository.dart';

class GetBusinessesByTypeUseCase {
  const GetBusinessesByTypeUseCase(this._repository);
  final BusinessRepository _repository;
  Future<List<Business>> call(String type) => _repository.getBusinessesByType(type);
}
