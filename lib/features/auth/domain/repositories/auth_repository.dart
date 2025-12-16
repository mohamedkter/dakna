import 'package:dakna/core/error/failures.dart';
import 'package:dakna/features/auth/data/models/user_model.dart';
import 'package:dakna/features/auth/domain/entities/user_entity.dart';
import 'package:dartz/dartz.dart';


abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> signInWithGoogle();

  Future<Either<Failure, UserModel>> signInWithFacebook();
  Future<Either<Failure, UserModel>> signInAsGuest();
  Future<Either<Failure , UserModel?>> getCurrentUser();
  Future<Either<Failure , void>> logout();
  Future<Either<Failure , bool>> isAuthenticated();
}
