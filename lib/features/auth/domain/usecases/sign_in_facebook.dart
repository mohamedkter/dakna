import 'package:dakna/core/error/failures.dart';
import 'package:dakna/features/auth/data/models/user_model.dart';
import 'package:dartz/dartz.dart';
import '../repositories/auth_repository.dart';

class SignInFacebook {
  final AuthRepository repository;

  SignInFacebook(this.repository);

  Future<Either<Failure, UserModel>> call() async {
    return await repository.signInWithFacebook();
  }
}
