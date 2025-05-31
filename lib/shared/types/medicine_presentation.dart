import 'package:meditrack/shared/types/medicines.dart';

class MedicinePresentation {
  final int id;
  final String url;
  final String name;
  final MedicineDto medicine;
  final String detentor;
  final String concentration;
  final String pharmaceuticalForm;

  MedicinePresentation({
    required this.id,
    required this.url,
    required this.name,
    required this.medicine,
    required this.detentor,
    required this.concentration,
    required this.pharmaceuticalForm,
  });

  factory MedicinePresentation.fromJson(Map<String, dynamic> json) {
    return MedicinePresentation(
      id: json['id'],
      url: json['url'],
      name: json['nome'],
      medicine: MedicineDto.fromJson(json['medicamento']),
      detentor: json['detentor'],
      concentration: json['concentracao'],
      pharmaceuticalForm: json['forma_farmaceutica'],
    );
  }
}
