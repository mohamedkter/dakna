import 'package:dakna/core/error/failures.dart';
import 'package:dakna/core/network/network_info.dart';
import 'package:dakna/features/auth/data/models/user_model.dart';
import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, UserModel>> signInWithGoogle() async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure());
    }
    try {
      final user = await remoteDataSource.signInWithGoogle();
      return Right(user);
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    } catch (e) {
      return Left(AuthFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, UserModel>> signInWithFacebook() async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure());
    }
    try {
      final user = await remoteDataSource.signInWithFacebook();
      return Right(user);
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    } catch (e) {
      return Left(AuthFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, UserModel>> signInAsGuest() async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure());
    }
    try {
      final user = await remoteDataSource.signInAsGuest();
      return Right(user);
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    } catch (e) {
      return Left(AuthFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }
}
