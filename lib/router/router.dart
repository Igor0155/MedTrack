import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meditrack/screens/add_medicament/screen.dart';
import 'package:meditrack/screens/auth/login/screen.dart';
import 'package:meditrack/screens/home/screen.dart';
import 'package:meditrack/screens/home/state.dart';

final GoRouter router = GoRouter(initialLocation: '/', routes: <RouteBase>[
  GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const LoginScreen();
      }),
  GoRoute(
      path: '/home',
      builder: (BuildContext context, GoRouterState state) {
        return const HomeApp();
      }),
  GoRoute(
      path: '/add_medicament',
      builder: (BuildContext context, GoRouterState state) {
        final MedicamentStateNotifier props = state.extra as MedicamentStateNotifier;
        return CreateMedicine(stateFire: props);
      })
]);
