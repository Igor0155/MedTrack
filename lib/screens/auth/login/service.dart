import 'package:meditrack/main.dart';
import 'package:meditrack/screens/auth/auth_config_state.dart';
import 'package:meditrack/screens/auth/login/controller.dart';
import 'package:meditrack/screens/auth/login/type.dart';
import 'package:meditrack/shared/services/client_http_interface.dart';
import 'package:meditrack/shared/services/client_shared_preferences_interface.dart';

class ServiceLogin {
  final loginController = LoginController(getIt.get<IClientSharedPreferences>());
  final authConfigState =
      AuthConfigState(client: getIt.get<IClientHttp>(), clientSharedPreferences: getIt.get<IClientSharedPreferences>());

  Future<OutputLoginDto> loginServiceExecute(InputLoginDto inputLoginDto) async {
    return await loginController.login(inputLoginDto);
  }
}
