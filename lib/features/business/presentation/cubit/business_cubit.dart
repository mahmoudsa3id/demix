import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/use_cases/get_businesses_by_type_use_case.dart';
import 'business_state.dart';

class BusinessCubit extends Cubit<BusinessState> {
  BusinessCubit({
    required GetBusinessesByTypeUseCase
        getBusinessesByType,
  })  : _getBusinessesByType =
            getBusinessesByType,
        super(const BusinessInitial());

  final GetBusinessesByTypeUseCase _getBusinessesByType;

  String? _currentType;

  Future<void> load(String type) async {
    final normalizedType =
        type.trim().toLowerCase();

    _currentType = normalizedType;

    emit(const BusinessLoading());

    final result =
        await _getBusinessesByType(
      normalizedType,
    );

    if (isClosed) return;

    result.fold(
      (failure) => emit(
        BusinessFailure(failure),
      ),
      (businesses) {
        if (businesses.isEmpty) {
          emit(
            BusinessEmpty(normalizedType),
          );
          return;
        }

        emit(
          BusinessLoaded(
            businesses: businesses,
            type: normalizedType,
          ),
        );
      },
    );
  }

  Future<void> retry() async {
    final type = _currentType;

    if (type == null || type!.isEmpty) {
      return;
    }

    await load(type!);
  }
}
