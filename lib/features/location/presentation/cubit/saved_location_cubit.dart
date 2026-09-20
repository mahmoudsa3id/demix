import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/location_entity.dart';
import '../../domain/use_cases/get_saved_location_use_case.dart';
import '../../domain/use_cases/delete_current_location_use_case.dart';

part 'saved_location_state.dart';

class SavedLocationCubit extends Cubit<SavedLocationState> {
  SavedLocationCubit({
    required this._getSavedLocation,
    required this._deleteCurrentLocation,
  }) : super(const SavedLocationInitial());

  final GetSavedLocationUseCase _getSavedLocation;
  final DeleteCurrentLocationUseCase _deleteCurrentLocation;

  Future<void> load() async {
    emit(const SavedLocationLoading());

    final result = await _getSavedLocation();

    result.fold(
      (failure) => emit(SavedLocationFailure(failure.message)),
      (location) => emit(SavedLocationLoaded(location)),
    );
  }

  Future<void> delete() async {
    final result = await _deleteCurrentLocation();

    result.fold(
      (failure) => emit(SavedLocationFailure(failure.message)),
      (_) => emit(const SavedLocationLoaded(null)),
    );
  }
}
