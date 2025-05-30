import 'package:flutter/material.dart';
import 'package:meditrack/screens/home/type/medicament.dart';
import 'package:meditrack/service/medicament_fire_service.dart';

class StateDetailsMedicine with ChangeNotifier {
  final MedicamentFireService _service = MedicamentFireService();
  MedicamentRepositoryFire? _content;
  MedicamentRepositoryFire? get content => _content;

  late bool isMedException;
  String medExceptionMessage = '';

  Future<void> findMedicine(String uidMedicine) async {
    try {
      isMedException = false;
      medExceptionMessage = '';
      notifyListeners();
      _content = await _service.buscarMedicamentoPorId(uidMedicine);
      notifyListeners();
    } catch (e) {
      medExceptionMessage = e.toString();
      isMedException = true;
      notifyListeners();
    }
  }
}
