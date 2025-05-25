import 'package:meditrack/shared/form_validator_build/form_validation_builder.dart';

enum Authenticated { authOk, authChangePassword, authError }

class InputLoginDto {
  String name;
  String login;
  String password;
  bool isSaveInputLogin;

  InputLoginDto({required this.login, required this.password, required this.isSaveInputLogin, required this.name});

  Map<String, dynamic> toJson() {
    return {
      'login': login,
      'password': password,
    };
  }

  StringValidationCallback isValidLogin() {
    return FormValidationBuilder().loginCelula().build();
  }

  StringValidationCallback isValidPassword() {
    return FormValidationBuilder().required().minLength(6).build();
  }
}

class OutputLoginDto {
  final bool changePasswordNextLogin;
  final String token;

  OutputLoginDto({required this.token, required this.changePasswordNextLogin});

  factory OutputLoginDto.fromJson(Map<String, dynamic> json) {
    return OutputLoginDto(
      token: json['token'],
      changePasswordNextLogin: json['change_password_next_login'],
    );
  }

  bool isValid() {
    if (token != "") {
      return true;
    } else {
      return false;
    }
  }
}
