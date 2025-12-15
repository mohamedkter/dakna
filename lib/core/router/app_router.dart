import 'package:dakna/features/auth/presentation/pages/login_page.dart' show LoginPage;
import 'package:dakna/features/auth/presentation/pages/signup_page.dart';
import 'package:dakna/features/home/presentation/pages/home_page.dart';
import 'package:go_router/go_router.dart';


class AppRouter {
  static GoRouter router = GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => LoginPage(),
      ),
      // GoRoute(
      //   path: '/signup',
      //   builder: (context, state) => SignupPage(),
      // ),
      GoRoute(
        path: '/home',
        builder: (context, state) => HomePage(),
      ),
    ],
  );
}
