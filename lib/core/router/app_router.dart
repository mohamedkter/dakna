import 'dart:async';
import 'package:dakna/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:dakna/features/auth/presentation/bloc/auth_state.dart';
import 'package:dakna/features/auth/presentation/pages/login_page.dart';
import 'package:dakna/features/auth/presentation/pages/splash_page.dart';
import 'package:dakna/features/home/presentation/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  final AuthBloc authBloc;

  AppRouter({required this.authBloc});

  late final GoRouter router = GoRouter(
    initialLocation: '/splash',
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
    redirect: (context, state) => _redirectLogic(state),
    routes: _routes,
  );

  String? _redirectLogic(GoRouterState state) {
    final authState = authBloc.state;

    final isSplash = state.matchedLocation == '/splash';
    final isLogin = state.matchedLocation == '/login';

    // ⏳ Loading / Initial → Splash
    if (authState is AuthInitial || authState is AuthLoading) {
      return isSplash ? null : '/splash';
    }

    // ❌ Not authenticated → Login
    if (authState is Unauthenticated) {
      return isLogin ? null : '/login';
    }

    // ✅ Authenticated → Home
    if (authState is Authenticated) {
      return state.matchedLocation == '/main' ? null : '/main';
    }

    return null;
  }
}
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
final List<GoRoute> _routes = [
  GoRoute(
    path: '/splash',
    builder: (_, __) => const SplashPage(),
  ),
  GoRoute(
    path: '/login',
    builder: (_, __) => const LoginPage(),
  ),
  GoRoute(
    path: '/main',
    builder: (_, __) => const MainPage(),
  ),
];
