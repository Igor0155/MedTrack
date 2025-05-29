class ApiMedicineResponse<T> {
  final int count;
  final String? next;
  final String? previous;
  final List<T> results;

  ApiMedicineResponse({
    required this.count,
    required this.next,
    required this.previous,
    required this.results,
  });

  factory ApiMedicineResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return ApiMedicineResponse(
      count: json['count'],
      next: json['next'],
      previous: json['previous'],
      results: (json['results'] as List).map((item) => fromJsonT(item as Map<String, dynamic>)).toList(),
    );
  }
}
