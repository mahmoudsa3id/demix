part of 'saved_location_cubit.dart';

sealed class SavedLocationState {
  const SavedLocationState();
}

class SavedLocationInitial extends SavedLocationState {
  const SavedLocationInitial();
}

class SavedLocationLoading extends SavedLocationState {
  const SavedLocationLoading();
}

class SavedLocationLoaded extends SavedLocationState {
  const SavedLocationLoaded(this.location);

  final LocationEntity? location;
}

class SavedLocationFailure extends SavedLocationState {
  const SavedLocationFailure(this.message);

  final String message;
}
