abstract class AuthEvent {}

class AppStarted extends AuthEvent {}

class SignInWithGooglePressed extends AuthEvent {}

class SignInWithFacebookPressed extends AuthEvent {}

class SignInAsGuestPressed extends AuthEvent {}

class LogoutPressed extends AuthEvent {}
