import 'package:dakna/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import '../repositories/auth_repository.dart';

class CheckAuthUsecase {
  final AuthRepository repository;

  CheckAuthUsecase(this.repository);

  Future<Either<Failure, bool>> call() async {
    return await repository.isAuthenticated();
  }
}
