import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meditrack/screens/auth/login/screen.dart';

final GoRouter router = GoRouter(initialLocation: '/', routes: <RouteBase>[
  GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const LoginScreen();
      })
]);
