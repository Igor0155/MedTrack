import 'package:meditrack/shared/services/client_http_interface.dart';
import 'package:meditrack/screens/auth/login/type.dart';
import 'package:meditrack/shared/services/client_shared_preferences_interface.dart';
import 'package:meditrack/shared/types/exception_type.dart';
import 'package:meditrack/shared/types/local_user_credentials.dart';

class LoginController {
  final IClientHttp _clientHttp;
  final IClientSharedPreferences _clientSharedPreferences;

  LoginController(this._clientHttp, this._clientSharedPreferences);

  // função para realizar o login e salvar o token e os dados de login(caso o usuário deseje) no localStorage
  Future<OutputLoginDto> login(InputLoginDto input) async {
    // limpa o token do localStorage
    await _clientSharedPreferences.clean("token");
    ClientHttpResponse response = await _clientHttp.post("/api/v1/auth/login", input.toJson());
    if (response.isSuccess) {
      final result = OutputLoginDto.fromJson(response.data);
      // verifica se o token é válido
      if (result.isValid()) {
        // salva o token no localStorage
        await _clientSharedPreferences.set("token", result.token);
        // verifica se o usuário deseja salvar os dados de login
        if (input.isSaveInputLogin) {
          // salva os dados de login no localStorage
          final credentials = LocalUserCredentials(u: input.login, p: input.password, n: '');
          await _clientSharedPreferences.set("il", credentials.toJson());
        } else {
          // limpa os dados de login do localStorage
          await _clientSharedPreferences.clean("il");
        }
        return result;
      }
      throw MediTrackException('Token Vazio');
    } else {
      throw MediTrackException(response.data['message']);
    }
  }

  // função para verificar se existe um usuário salvo localmente e se sim, atribuir o nome a ele
  Future<void> assignUsernameIfLocalDataExists(String name) async {
    // verifica se existe um usuário salvo localmente
    if (await _clientSharedPreferences.containsKey('il')) {
      // pega os dados de login salvos localmente
      final data = await _clientSharedPreferences.get('il');
      // verifica se os dados de login são válidos
      if (data == null) return;
      // atribui o nome ao usuário
      final credentials = LocalUserCredentials.fromJson(data);
      credentials.n = name;
      // salva os dados de login com o nome no localStorage
      await _clientSharedPreferences.set("il", credentials.toJson());
    }
  }
}
