import 'package:dakna/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:dakna/features/auth/domain/usecases/is_authenticated_usecase.dart';
import 'package:dakna/features/auth/domain/usecases/log_out_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/sign_in_google.dart';
import '../../domain/usecases/sign_in_facebook.dart';
import '../../domain/usecases/sign_in_guest.dart.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInWithGoogleUsecase signInGoogle;
  final SignInFacebook signInFacebook;
  final SignInGuest signInGuest;
  final GetCurrentUserUsecase getCurrentUser;
  final IsAuthenticatedUsecase isAuthenticated;
  final LogoutUsecase logout;

  AuthBloc({
    required this.signInGoogle,
    required this.signInFacebook,
    required this.signInGuest,
    required this.getCurrentUser,
    required this.isAuthenticated,
    required this.logout,
  }) : super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<SignInWithGooglePressed>(_onSignInWithGoogle);
    on<SignInWithFacebookPressed>(_onSignInWithFacebook);
    on<SignInAsGuestPressed>(_onSignInAsGuest);
    on<LogoutPressed>(_onLogout);
  }
Future<void> _onAppStarted(
  AppStarted event,
  Emitter<AuthState> emit,
) async {
  emit(AuthLoading());

  final authResult = await isAuthenticated();

  final isAuth = authResult.getOrElse(() => false);

  if (!isAuth) {
    emit(Unauthenticated());
    return;
  }

  final userResult = await getCurrentUser();

  userResult.fold(
    (_) => emit(Unauthenticated()),
    (user) => emit(
      user != null
          ? Authenticated(user)
          : Unauthenticated(),
    ),
  );
}

   Future<void> _onSignInWithGoogle(
    SignInWithGooglePressed event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await signInGoogle();
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => emit(Authenticated(user)),
    );
  }

  Future<void> _onSignInWithFacebook(
    SignInWithFacebookPressed event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await signInFacebook();
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => emit(Authenticated(user)),
    );
  }

  Future<void> _onSignInAsGuest(
    SignInAsGuestPressed event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await signInGuest();
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => emit(Authenticated(user)),
    );
  }

  Future<void> _onLogout(
    LogoutPressed event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await logout();
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (_) => emit(Unauthenticated()),
    );
  }
}
