import 'package:meditrack/shared/form_validator_build/form_validation_builder.dart';

class MedicamentRepositoryFire {
  String authorUid;
  String id;
  String medicineName;
  int medicineId;
  String dosage;
  String formaFarm;
  String duration;
  String description;

  MedicamentRepositoryFire({
    required this.authorUid,
    required this.id,
    required this.medicineName,
    required this.medicineId,
    required this.dosage,
    required this.formaFarm,
    required this.duration,
    required this.description,
  });

  factory MedicamentRepositoryFire.fromJson(Map<String, dynamic> json, String documentId) {
    return MedicamentRepositoryFire(
      authorUid: json['author_uid'] ?? '',
      id: documentId,
      medicineName: json['name'] ?? '',
      medicineId: json['medicineId'] ?? '',
      dosage: json['dosage'] ?? '',
      formaFarm: json['formaFarm'] ?? '',
      duration: json['duration'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson(String authorUid) {
    return {
      'author_uid': authorUid,
      'name': medicineName,
      'medicineId': medicineId,
      'dosage': dosage,
      'formaFarm': formaFarm,
      'duration': duration,
      'description': description,
    };
  }

  StringValidationCallback isRequired() {
    return FormValidationBuilder().required().build();
  }
}


// 3. Dados da prescrição
// Nome do medicamento (preferencialmente o nome genérico)

// Dosagem (ex: 500 mg, 10 mg/mL)

// Forma farmacêutica (comprimido, cápsula, solução oral, injetável etc.)

// Posologia (quantidade, frequência e duração: ex: "1 comprimido de 8 em 8 horas por 7 dias")

// Via de administração (oral, intramuscular, intravenosa, tópica etc.)

// Quantidade total a ser fornecida (em especial para antibióticos e controlados)