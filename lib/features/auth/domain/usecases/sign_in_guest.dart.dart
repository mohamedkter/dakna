import 'package:dakna/features/auth/data/models/user_model.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';

class SignInGuest {
  final AuthRepository repository;

  SignInGuest(this.repository);

  Future<Either<Failure, UserModel>> call() async {
    return await repository.signInAsGuest();
  }
}