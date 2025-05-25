import 'package:firebase_auth/firebase_auth.dart';
import 'package:meditrack/screens/auth/login/type.dart';
import 'package:meditrack/shared/services/client_shared_preferences_interface.dart';
import 'package:meditrack/shared/types/exception_type.dart';
import 'package:meditrack/shared/types/local_user_credentials.dart';

class LoginController {
  final IClientSharedPreferences _clientSharedPreferences;

  LoginController(this._clientSharedPreferences);

  // função para realizar o login e salvar o token e os dados de login(caso o usuário deseje) no localStorage
  Future<OutputLoginDto> login(InputLoginDto input) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: input.login,
        password: input.password,
      );

      var token = await FirebaseAuth.instance.currentUser?.getIdToken();

      await _clientSharedPreferences.set("token", token);

      if (input.isSaveInputLogin) {
        final credentials = LocalUserCredentials(u: input.login, p: input.password, n: input.login.split('@')[0]);
        await _clientSharedPreferences.set("il", credentials.toJson());
      } else {
        await _clientSharedPreferences.clean("il");
      }
      return OutputLoginDto(token: token ?? '');
    } on FirebaseAuthException catch (e) {
      throw MediTrackException(e.message ?? 'Erro desconhecido no login Firebase');
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
