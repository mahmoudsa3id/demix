import 'package:demix/features/business/domain/entities/business.dart';
import 'package:demix/features/business/domain/repositories/business_repository.dart';

class GetAllBusinessesUseCase {
  GetAllBusinessesUseCase({required BusinessRepository repository})
    : _repository = repository;

  final BusinessRepository _repository;

  Future<List<Business>> call() {
    return _repository.getAllBusinesses();
  }
}
