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
    return FormValidationBuilder().required().build();
  }

  StringValidationCallback isValidPassword() {
    return FormValidationBuilder().required().minLength(6).build();
  }
}
