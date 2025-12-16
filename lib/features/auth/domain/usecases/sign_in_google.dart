import 'package:dakna/core/error/failures.dart';
import 'package:dakna/features/auth/domain/entities/user_entity.dart';
import 'package:dartz/dartz.dart';  
import '../repositories/auth_repository.dart';


class SignInWithGoogleUsecase {
  final AuthRepository repository;

  SignInWithGoogleUsecase(this.repository);

  Future<Either<Failure, UserEntity>> call() {
    return repository.signInWithGoogle();
  }
}
