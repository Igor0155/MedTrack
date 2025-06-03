// medicamento_notifier.dart
import 'package:flutter/foundation.dart';
import 'package:meditrack/screens/home/type/medicament.dart';
import 'package:meditrack/service/medicament_fire_service.dart';
import 'package:meditrack/shared/stores/local_notifications.dart';

class MedicamentStateNotifier extends ChangeNotifier {
  final MedicamentFireService _service = MedicamentFireService();
  final NotificationService _notificationService = NotificationService();
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

      await scheduleNotification();

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

  Future<void> remove(MedicamentRepositoryFire medicament) async {
    try {
      await _service.deletarMedicamento(medicament.id);
      _list?.remove(medicament);
      notifyListeners();
    } catch (e) {
      throw Exception('Erro ao remover medicamento: $e');
    }
  }

  Future<void> scheduleNotification() async {
    try {
      await _notificationService.cancelAllNotifications(); // OU um método mais específico
      if (_list != null) {
        for (var medRepo in _list!) {
          final MedicamentRepositoryFire medication = MedicamentRepositoryFire(
            id: medRepo.id,
            authorUid: medRepo.authorUid,
            description: medRepo.description,
            dosage: medRepo.dosage,
            dosageIntervalHours: medRepo.dosageIntervalHours,
            durationDays: medRepo.durationDays,
            formaFarm: medRepo.formaFarm,
            medicationStartDatetime: medRepo.medicationStartDatetime,
            medicineId: medRepo.medicineId,
            medicineName: medRepo.medicineName,
          );
          await _notificationService.scheduleMedicationNotifications(medication);
        }
      }
    } catch (e) {
      throw Exception('Erro ao agendar notificação: $e');
    }
  }
}
