import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demix/features/business/domain/entities/business_page.dart';
import 'package:demix/features/business/domain/repositories/business_repository.dart';

class GetBusinessesPageUseCase {
  GetBusinessesPageUseCase({required this._repository});

  final BusinessRepository _repository;

  Future<BusinessPage> call({
    required String type,
    required String languageCode,
    String? search,
    DocumentSnapshot<Map<String, dynamic>>? lastDocument,
    int limit = 10,
  }) {
    return _repository.getBusinessesPage(
      type: type,
      languageCode: languageCode,
      search: search,
      lastDocument: lastDocument,
      limit: limit,
    );
  }
}
