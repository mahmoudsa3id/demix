import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/location_entity.dart';
import '../../domain/use_cases/get_saved_location_use_case.dart';

part 'saved_location_state.dart';

class SavedLocationCubit extends Cubit<SavedLocationState> {
  SavedLocationCubit({required GetSavedLocationUseCase getSavedLocation})
    : _getSavedLocation = getSavedLocation,
      super(const SavedLocationInitial());

  final GetSavedLocationUseCase _getSavedLocation;

  Future<void> load() async {
    emit(const SavedLocationLoading());

    final result = await _getSavedLocation();

    result.fold(
      (failure) => emit(SavedLocationFailure(failure.message)),
      (location) => emit(SavedLocationLoaded(location)),
    );
  }
}
