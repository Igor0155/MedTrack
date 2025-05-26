class Medicament {
  String id;
  String name;
  String dosage;
  String formaFarm;
  String quantity;
  String duration;
  String description;

  Medicament({
    required this.id,
    required this.name,
    required this.dosage,
    required this.formaFarm,
    required this.quantity,
    required this.duration,
    required this.description,
  });

  factory Medicament.fromJson(Map<String, dynamic> json, String documentId) {
    return Medicament(
      id: documentId,
      name: json['name'] ?? '',
      dosage: json['dosage'] ?? '',
      formaFarm: json['formaFarm'] ?? '',
      quantity: json['quantity'] ?? '',
      duration: json['duration'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'dosage': dosage,
      'formaFarm': formaFarm,
      'quantity': quantity,
      'duration': duration,
      'description': description,
    };
  }
}


// 3. Dados da prescrição
// Nome do medicamento (preferencialmente o nome genérico)

// Dosagem (ex: 500 mg, 10 mg/mL)

// Forma farmacêutica (comprimido, cápsula, solução oral, injetável etc.)

// Posologia (quantidade, frequência e duração: ex: "1 comprimido de 8 em 8 horas por 7 dias")

// Via de administração (oral, intramuscular, intravenosa, tópica etc.)

// Quantidade total a ser fornecida (em especial para antibióticos e controlados)