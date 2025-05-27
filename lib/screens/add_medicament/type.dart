class OutputBularioDto {
  final List<MedicamentoDto> medicaments;

  OutputBularioDto({required this.medicaments});

  factory OutputBularioDto.fromJson(Map<String, dynamic> json) {
    return OutputBularioDto(
      medicaments: json.values.map((e) => MedicamentoDto.fromJson(e)).toList(),
    );
  }
}

class MedicamentoDto {
  final int idProduto;
  final String nomeProduto;
  final String numeroRegistro;
  final String numProcesso;

  MedicamentoDto({
    required this.idProduto,
    required this.nomeProduto,
    required this.numeroRegistro,
    required this.numProcesso,
  });

  factory MedicamentoDto.fromJson(Map<String, dynamic> json) {
    return MedicamentoDto(
      idProduto: json['idProduto'] ?? 0,
      nomeProduto: json['nomeProduto'] ?? '',
      numeroRegistro: json['numeroRegistro'] ?? '',
      numProcesso: json['numProcesso'] ?? '',
    );
  }
}
