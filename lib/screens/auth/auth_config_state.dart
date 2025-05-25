import 'package:flutter/material.dart';
import 'package:meditrack/shared/services/client_http_interface.dart';
import 'package:meditrack/shared/services/client_shared_preferences_interface.dart';
import 'package:meditrack/shared/types/local_user_credentials.dart';

// Usando o método singleton para criar uma instancia de AuthConfigState
class AuthConfigState extends ChangeNotifier {
  // Criação da instância de AuthConfigState usando o construtor interno
  static final AuthConfigState _instance = AuthConfigState._internal();

  // Fctory que retorna a instância singleton de AuthConfigState, inicializando o client se necessário
  factory AuthConfigState({required IClientHttp client, required IClientSharedPreferences clientSharedPreferences}) {
    // Inicializa o client e sharedPref se ainda não foram definidos
    _instance.client ??= client;
    _instance.clientSharedPreferences ??= clientSharedPreferences;
    return _instance;
  }

  // Construtor interno privado
  AuthConfigState._internal();

  IClientHttp? client;
  IClientSharedPreferences? clientSharedPreferences;

  bool isLoading = true;
  bool isGEDocsException = false;

  bool containsLoginSaved = false;

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  // Função para verificar se existe um usuário salvo localmente e se sim, retorna as informações de autenticação do usuário
  Future<LocalUserCredentials?> checkUserLoginInSecureStorage() async {
    // Avisando que está carregando e que não contém login salvo de inicio
    containsLoginSaved = false;
    isLoading = true;
    notifyListeners();
    try {
      // Verificando se existe login salvo no dispositivo
      final isLoginAvailable = await clientSharedPreferences!.get('il');
      // Verificando se o login não está vazio ou nulo
      if (isLoginAvailable != null && isLoginAvailable.isNotEmpty) {
        // Avisando que tem um login salvo no dispositivo
        containsLoginSaved = true;
        notifyListeners();

        // retorna o login decodificado
        return LocalUserCredentials.fromJson(isLoginAvailable);
      }
      // Caso não tenha login salvo, retorna null
      return null;
    } catch (e) {
      // Caso de erro ao buscar o login, retorna null e limpa o login salvo e avisa que não contém login salvo
      containsLoginSaved = false;
      notifyListeners();
      await clientSharedPreferences!.clean('il');
      return null;
    } finally {
      // Avisando que parou de carregar
      isLoading = false;
      notifyListeners();
    }
  }

  // Função para limpar o login salvo no dispositivo e avisar que não contém login salvo
  Future<void> changeMethodLoginSaved() async {
    containsLoginSaved = false;
    isLoading = true;
    notifyListeners();
    try {
      await clientSharedPreferences!.clean('il');
    } catch (e) {
      return;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
