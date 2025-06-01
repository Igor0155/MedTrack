import 'package:flutter/material.dart';
import 'package:meditrack/service/medicament_fire_service.dart';
import 'package:meditrack/shared/services/dio_client_medicine.dart';
import 'package:meditrack/shared/types/api_medicine_response.dart';
import 'package:meditrack/shared/types/medicine_presentation.dart';

class StateHistoryMedicine with ChangeNotifier {
  final _service = MedicamentFireService();
  final DioClientMedicine clientMedicine;
  var isLoading = true;
  late bool medException;
  late String medExceptionMessage;

  ApiMedicineResponse<MedicinePresentation>? _medicines;
  ApiMedicineResponse<MedicinePresentation>? get medicines => _medicines;

  StateHistoryMedicine({required this.clientMedicine});

  Future<void> loadingMedicine() async {
    try {
      medExceptionMessage = '';
      isLoading = true;
      medException = false;
      notifyListeners();
      var listIdsMedicine = await _service.buscarTodosMedicamentosIds();

      // Transforma a lista de ints em uma string do tipo "?medicamento=3&medicamento=32"
      String query = listIdsMedicine.isNotEmpty ? '?${listIdsMedicine.map((m) => 'medicamento=$m').join('&')}' : '';

      if (query.isEmpty) {
        isLoading = false;
        notifyListeners();
        return;
      }

      var response = await clientMedicine.get('/v1/apresentacao-medicamentos/$query');

      _medicines = ApiMedicineResponse<MedicinePresentation>.fromJson(
        response.data,
        (json) => MedicinePresentation.fromJson(json),
      );

      isLoading = false;
      notifyListeners();
    } catch (e) {
      medExceptionMessage = e.toString();
      isLoading = false;
      medException = true;
      notifyListeners();
    }
  }
}
