import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:meditrack/screens/add_medicament/type.dart';
import 'package:meditrack/shared/services/client_http_interface.dart';

class AddMedicamentState with ChangeNotifier {
  final IClientHttp client;
  bool isLoading = true;

  OutputBularioDto? _getMedicaments;
  OutputBularioDto? get getMedicaments => _getMedicaments;

  bool isMedException = false;
  String medExceptionMessage = '';

  AddMedicamentState({required this.client});

  Future<void> searchMedicaments() async {
    try {
      isLoading = true;
      notifyListeners();
      isMedException = false;
      final dio = Dio(BaseOptions(baseUrl: 'http://10.0.2.2:8000/'));
      var response = await dio.get('/medicines/');
      if (response.statusCode == 200) {
        _getMedicaments = OutputBularioDto.fromJson(response.data);
        isLoading = false;
        notifyListeners();
      } else {
        throw Exception('Erro ao buscar medicamentos: ${response.statusCode}');
      }
    } catch (e) {
      isLoading = false;
      isMedException = true;
      medExceptionMessage = "Erro ao buscar medicamentos: $e";
      notifyListeners();
    }
  }

  // Future<bool> update(String fsFileCuid, InputUpdateDto input) async {
  //   isLoading = true;
  //   isGEDocsException = false;
  //   notifyListeners();

  //   final String url = '/api/v1/customer/fs/file/$fsFileCuid';
  //   var response = await client.patch(url, input.toJson());
  //   if (response.isSuccess) {
  //     isLoading = false;
  //     notifyListeners();
  //     return true;
  //   } else {
  //     isLoading = false;
  //     notifyListeners();
  //     throw GEDocsException(response.data['message']);
  //   }
  // }
}
