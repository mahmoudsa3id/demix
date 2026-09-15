import 'package:demix/features/business/domain/entities/business.dart';
import 'package:demix/features/business/domain/repositories/business_repository.dart';

class GetBusinessByIdUseCase {
  const GetBusinessByIdUseCase(this._repository);
  final BusinessRepository _repository;
  Future<Business> call(String businessId) => _repository.getBusinessById(businessId);
}
