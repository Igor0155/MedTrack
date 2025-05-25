class Medicament {
  final String id;
  final String name;
  final String dosage;
  final String fabricator;
  final String description;

  Medicament({
    required this.id,
    required this.name,
    required this.dosage,
    required this.fabricator,
    required this.description,
  });

  factory Medicament.fromJson(Map<String, dynamic> json, String documentId) {
    return Medicament(
      id: documentId,
      name: json['name'] ?? '',
      dosage: json['dosage'] ?? '',
      fabricator: json['fabricator'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'dosage': dosage,
      'fabricator': fabricator,
      'description': description,
    };
  }
}
