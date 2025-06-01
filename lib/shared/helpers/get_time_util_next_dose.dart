import 'package:meditrack/screens/home/type/medicament.dart';

Duration? getTimeUntilNextDose(MedicamentRepositoryFire medication) {
  final DateTime startDate = DateTime.parse(medication.medicationStartDatetime);
  final DateTime now = DateTime.now();
  final DateTime endDate = startDate.add(Duration(days: medication.durationDays));

  if (now.isBefore(startDate)) {
    return startDate.difference(now);
  }

  if (now.isAfter(endDate)) {
    return null; // Tratamento finalizado
  }

  DateTime nextDoseTime = startDate;
  while (nextDoseTime.isBefore(now) && nextDoseTime.isBefore(endDate)) {
    nextDoseTime = nextDoseTime.add(Duration(hours: medication.dosageIntervalHours));
  }

  if (nextDoseTime.isAfter(endDate)) {
    return null; // Não há mais doses no período
  }

  return nextDoseTime.difference(now);
}
