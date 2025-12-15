import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SignInWithGooglePressed extends AuthEvent {}

class SignInWithFacebookPressed extends AuthEvent {}

class SignInAsGuestPressed extends AuthEvent {}