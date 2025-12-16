import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dakna/core/network/connectivity_plus.dart';
import 'package:dakna/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:dakna/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:dakna/features/auth/domain/usecases/is_authenticated_usecase.dart';
import 'package:dakna/features/auth/domain/usecases/log_out_usecase.dart';
import 'package:dakna/features/auth/domain/usecases/sign_in_guest.dart.dart';
import 'package:get_it/get_it.dart';
import 'package:dakna/core/network/network_info.dart';
import 'package:dakna/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:dakna/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:dakna/features/auth/domain/repositories/auth_repository.dart';
import 'package:dakna/features/auth/domain/usecases/sign_in_facebook.dart';
import 'package:dakna/features/auth/domain/usecases/sign_in_google.dart';
import 'package:dakna/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  //! Bloc
  sl.registerFactory(
    () => AuthBloc(
      signInGoogle: sl(),
      signInFacebook: sl(),
      signInGuest: sl(),
      getCurrentUser: sl(),
      isAuthenticated: sl(),
      logout: sl(),
    ),
  );

  //! UseCases
  sl.registerLazySingleton(() => SignInGoogle(sl()));
  sl.registerLazySingleton(() => SignInFacebook(sl()));
  sl.registerLazySingleton(() => SignInGuest(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUsecase(sl()));
  sl.registerLazySingleton(() => IsAuthenticatedUsecase(sl()));
  sl.registerLazySingleton(() => LogoutUsecase(sl()));
  //! Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
      authLocalDataSource: sl(),
    ),
  );

  //! Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sharedPreferences: sl()),
  );

  //! Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(Connectivity()));
}
