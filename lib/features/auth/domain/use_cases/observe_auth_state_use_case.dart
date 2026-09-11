import 'package:demix/features/auth/domain/entities/auth_session.dart';
import 'package:demix/features/auth/domain/repository/auth_repository.dart';

class ObserveAuthStateUseCase {
  const ObserveAuthStateUseCase(this._repository);

  final AuthRepository _repository;

  Stream<AuthSession?> call() {
    return _repository.authStateChanges;
  }
}
