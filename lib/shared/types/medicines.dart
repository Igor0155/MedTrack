class OutputMedicinesDto {
  final List<MedicineDto> medicines;

  OutputMedicinesDto({required this.medicines});

  factory OutputMedicinesDto.fromJson(Map<String, dynamic> json) {
    return OutputMedicinesDto(
        medicines:
            (json['results'] as List<dynamic>).map((i) => MedicineDto.fromJson(i as Map<String, dynamic>)).toList());
  }
}

class MedicineDto {
  final int id;
  final String url;
  final String name;
  final List<String> ingredientsActiveAnvisa;
  final List<PrinciplesActivesDto> principlesActives;

  MedicineDto({
    required this.id,
    required this.url,
    required this.name,
    required this.ingredientsActiveAnvisa,
    required this.principlesActives,
  });

  factory MedicineDto.fromJson(Map<String, dynamic> json) {
    return MedicineDto(
      id: json['id'],
      url: json['url'],
      name: json['nome'],
      ingredientsActiveAnvisa: List<String>.from(json['principios_ativos_anvisa'] ?? []),
      principlesActives: (json['principios_ativos'] as List<dynamic>)
          .map((item) => PrinciplesActivesDto.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class PrinciplesActivesDto {
  final int id;
  final String url;
  final String name;

  PrinciplesActivesDto({
    required this.id,
    required this.url,
    required this.name,
  });

  factory PrinciplesActivesDto.fromJson(Map<String, dynamic> json) {
    return PrinciplesActivesDto(
      id: json['id'],
      url: json['url'],
      name: json['nome'],
    );
  }
}
