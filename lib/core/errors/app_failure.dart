enum FailureKind {
  cancelled,
  configuration,
  network,
  notFound,
  permissionDenied,
  rateLimited,
  server,
  unauthenticated,
  validation,
  unknown,
}

class AppFailure {
  const AppFailure({
    required this.kind,
    required this.message,
    this.code,
    this.cause,
  });

  final FailureKind kind;
  final String message;
  final String? code;
  final Object? cause;

  bool get isAuthFailure => kind == FailureKind.unauthenticated;

  @override
  String toString() {
    final suffix = code == null ? '' : ' ($code)';
    return '$message$suffix';
  }
}

class AuthFailure extends AppFailure {
  const AuthFailure({
    required super.message,
    super.code,
    super.cause,
    super.kind = FailureKind.unauthenticated,
  });
}
