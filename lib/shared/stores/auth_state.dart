import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meditrack/shared/helpers/convert_token_string_to_info_token.dart';
import 'package:meditrack/shared/types/info_token_type.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

class AuthState {
  final bool isAuthenticated;
  final InfoToken? infoToken;
  AuthState({this.isAuthenticated = false, this.infoToken});
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState(isAuthenticated: false, infoToken: null));

  void login(String token) {
    var infoToken = convertTokenStringToInfoToken(token);
    if (infoToken == null) {
      return;
    }
    state = AuthState(isAuthenticated: true, infoToken: infoToken);
  }

  void logout() {
    state = AuthState(isAuthenticated: false, infoToken: null);
  }

  void changeToken(String token) {
    state = AuthState(isAuthenticated: false, infoToken: null);

    var infoToken = convertTokenStringToInfoToken(token);
    if (infoToken == null) {
      return;
    }
    state = AuthState(isAuthenticated: true, infoToken: infoToken);
  }
}
