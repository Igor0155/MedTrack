import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meditrack/shared/form_validator_build/form_validation_builder.dart';
import 'package:meditrack/shared/helpers/format_date.dart';

class MedicamentRepositoryFire {
  String id; // ID do documento no Firestore
  String authorUid; // ID do usuário que criou o medicamento
  String description; // Descrição do medicamento
  String dosage; // Dosagem do medicamento 500 (ex: 500 mg, 10 mg/mL)
  int dosageIntervalHours; // Intervalo de dosagem em horas ex: 8 (1 comprimido a cada 8 horas)
  int durationDays; // Duração do tratamento em dias ex: 7( 7 dias)
  String formaFarm; // Forma farmacêutica (comprimido, cápsula, solução oral, injetável etc.)
  String medicationStartDatetime; // Data e hora de início do medicamento
  int medicineId; // ID do medicamento
  String medicineName; // Nome do medicamento

  MedicamentRepositoryFire({
    required this.authorUid,
    required this.id,
    required this.medicineName,
    required this.dosage,
    required this.medicineId,
    required this.dosageIntervalHours,
    required this.formaFarm,
    required this.durationDays,
    required this.medicationStartDatetime,
    required this.description,
  });

  factory MedicamentRepositoryFire.fromJson(Map<String, dynamic> json, String documentId) {
    return MedicamentRepositoryFire(
      authorUid: json['author_uid'] ?? '',
      id: documentId,
      medicineName: json['name'] ?? '',
      medicineId: json['medicineId'] ?? 0,
      medicationStartDatetime: FormatDate().formatFirestoreTimestamp(json['medication_start_datetime'] ?? ''),
      dosage: json['dosage'] ?? '',
      dosageIntervalHours: json['dosage_interval_hours'] ?? 0,
      formaFarm: json['formaFarm'] ?? '',
      durationDays: json['duration_days'] ?? 0,
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson(String authorUid) {
    return {
      'author_uid': authorUid,
      'name': medicineName,
      'medicineId': medicineId,
      'dosage_interval_hours': dosageIntervalHours,
      'medication_start_datetime': Timestamp.fromDate(FormatDate().parseBrazilianDateTime(medicationStartDatetime)),
      'dosage': dosage,
      'formaFarm': formaFarm,
      'duration_days': durationDays,
      'description': description,
    };
  }

  StringValidationCallback isRequired() {
    return FormValidationBuilder().required().build();
  }

  StringValidationCallback isValidDate() {
    return FormValidationBuilder().required().dateTime().build();
  }
}

enum PharmaceuticalFormEnum {
  comprimido('CMP', 'Comprimido'),
  capsula('CAP', 'Cápsula'),
  solucaoOral('SOL', 'Solução Oral'),
  injetavel('INJ', 'Injetável'),
  outro('OUT', 'Outro');

  final String key;
  final String label;

  const PharmaceuticalFormEnum(this.key, this.label);

  static String? labelFromKey(String key) {
    for (var form in PharmaceuticalFormEnum.values) {
      if (form.key == key) return form.label;
    }
    return null;
  }
}
