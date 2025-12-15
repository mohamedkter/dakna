import 'package:dakna/features/auth/domain/usecases/sign_in_guest.dart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/sign_in_google.dart';
import '../../domain/usecases/sign_in_facebook.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInGoogle signInGoogle;
  final SignInFacebook signInFacebook;
  final SignInGuest signInGuest;

  AuthBloc({
    required this.signInGoogle,
    required this.signInFacebook,
    required this.signInGuest,
  }) : super(AuthInitial()) {
    on<SignInWithGooglePressed>(_onSignInWithGoogle);
    on<SignInWithFacebookPressed>(_onSignInWithFacebook);
    on<SignInAsGuestPressed>(_onSignInAsGuest);
  }

  Future<void> _onSignInWithGoogle(
    SignInWithGooglePressed event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await signInGoogle();
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => emit(AuthSuccess(user)),
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
      (user) => emit(AuthSuccess(user)),
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
      (user) => emit(AuthSuccess(user)),
    );
  }
}

class NoParams {
}