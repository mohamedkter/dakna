abstract class Failure {
  final String message;
  const Failure({required this.message});
}

class AuthFailure extends Failure {
  const AuthFailure({required String message}) : super(message: message);
}

class NetworkFailure extends Failure {
  const NetworkFailure({String message = "No internet connection"}) : super(message: message);
}
