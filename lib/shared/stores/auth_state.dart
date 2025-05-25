import 'package:flutter_riverpod/flutter_riverpod.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

class AuthState {
  final bool isAuthenticated;
  AuthState({this.isAuthenticated = false});
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState(isAuthenticated: false));

  void login(String token) {
    state = AuthState(isAuthenticated: true);
  }

  void logout() {
    state = AuthState(isAuthenticated: false);
  }

  void changeToken(String token) {
    state = AuthState(isAuthenticated: false);

    state = AuthState(isAuthenticated: true);
  }
}
