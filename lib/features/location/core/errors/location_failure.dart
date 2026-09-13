enum LocationFailureKind {
  serviceDisabled,
  permissionDenied,
  permissionDeniedForever,
  gps,
  network,
  geocoding,
  database,
  unauthenticated,
  permissionDeniedRemote,
  validation,
  unknown,
}

class LocationFailure {
  const LocationFailure({
    required this.kind,
    required this.message,
    this.code,
    this.cause,
  });

  final LocationFailureKind kind;
  final String message;
  final String? code;
  final Object? cause;

  @override
  String toString() => code == null ? message : '$message ($code)';
}
