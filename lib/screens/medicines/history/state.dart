import 'package:flutter/material.dart';
import 'package:meditrack/service/medicament_fire_service.dart';
import 'package:meditrack/shared/services/dio_client_medicine.dart';
import 'package:meditrack/shared/types/medicines.dart';

class StateHistoryMedicine with ChangeNotifier {
  final _service = MedicamentFireService();
  final DioClientMedicine clientMedicine;
  var isLoading = true;
  late bool medException;
  late String medExceptionMessage;

  List<MedicineDto>? _medicines;
  List<MedicineDto>? get medicines => _medicines;

  StateHistoryMedicine({required this.clientMedicine});

  Future<void> loadingMedicine() async {
    try {
      medExceptionMessage = '';
      isLoading = true;
      medException = false;
      notifyListeners();
      var listIdsMedicine = (await _service.buscarTodosMedicamentosIds()).toSet().toList();

      List<MedicineDto> list = List.of([]);
      for (var i in listIdsMedicine) {
        var response = await clientMedicine.get('/v1/medicamentos/$i/');
        list.add(MedicineDto.fromJson(response.data));
      }

      _medicines = list;
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
