import 'dart:convert';

// classe que representa as credenciais do usuário salvas localmente
class LocalUserCredentials {
  String u; // login
  String p; // password
  String n; // name

  LocalUserCredentials({required this.u, required this.p, required this.n});
  // Converte o JSON (String) para o objeto Map
  factory LocalUserCredentials.fromJson(String jsonString) {
    final Map<String, dynamic> json = jsonDecode(jsonString);
    return LocalUserCredentials(u: json['u'] ?? '', p: json['p'] ?? '', n: json['n'] ?? '');
  }
  // Converte o objeto para JSON (String)
  String toJson() {
    return jsonEncode({'u': u, 'p': p, 'n': n});
  }
}
