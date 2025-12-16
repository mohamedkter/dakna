import 'package:dakna/core/error/failures.dart';
import 'package:dakna/features/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

class IsAuthenticatedUsecase {
  final AuthRepository repo;
  IsAuthenticatedUsecase(this.repo);
  Future<Either<Failure, bool>> call() {
    return repo.isAuthenticated();
  }
}
