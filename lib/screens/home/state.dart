// medicamento_notifier.dart
import 'package:flutter/foundation.dart';
import 'package:meditrack/screens/home/type/medicament.dart';
import 'package:meditrack/service/medicament_fire_service.dart';

class MedicamentStateNotifier extends ChangeNotifier {
  final MedicamentFireService _service = MedicamentFireService();
  List<Medicament> _list = [];
  List<Medicament> get list => _list;
  var isLoading = true;
  var isMedException = false;

  MedicamentStateNotifier() {
    _service.listarMedicamentos().listen((meds) {
      _list = meds;
      isLoading = false;
      notifyListeners();
    });
  }

  Future<void> add(Medicament m) async {
    isLoading = true;
    await _service.adicionarMedicamento(m);
    isLoading = false;
  }

  Future<void> update(Medicament m) async {
    isLoading = true;
    await _service.atualizarMedicamento(m);
    isLoading = false;
  }

  Future<void> delete(String id) async {
    isLoading = true;
    await _service.deletarMedicamento(id);
    isLoading = false;
  }
}
