// medicamento_notifier.dart
import 'package:flutter/foundation.dart';
import 'package:meditrack/screens/home/type/medicament.dart';
import 'package:meditrack/service/medicament_fire_service.dart';

class MedicamentStateNotifier extends ChangeNotifier {
  final MedicamentFireService _service = MedicamentFireService();
  List<MedicamentRepositoryFire>? _list;
  List<MedicamentRepositoryFire>? get list => _list;
  var isLoading = true;
  var isMedException = false;
  var medExceptionMessage = '';

  Future<void> fetchMedicaments() async {
    try {
      isMedException = false;
      medExceptionMessage = '';
      isLoading = true;
      notifyListeners();
      _list = await _service.buscarMedicamentos();
      isLoading = false;
      notifyListeners();
    } catch (e) {
      medExceptionMessage = e.toString();
      isMedException = true;
      isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  refresHome() async {
    _list = null;
    notifyListeners();
    await fetchMedicaments();
  }

  // Future<void> add(MedicamentRepositoryFire m) async {
  //   isLoading = true;
  //   await _service.adicionarMedicamento(m);
  //   isLoading = false;
  // }

  // Future<void> update(MedicamentRepositoryFire m) async {
  //   isLoading = true;
  //   await _service.atualizarMedicamento(m);
  //   isLoading = false;
  // }

  // Future<void> delete(String id) async {
  //   isLoading = true;
  //   await _service.deletarMedicamento(id);
  //   isLoading = false;
  // }
}
