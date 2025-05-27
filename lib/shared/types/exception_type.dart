class MedTrackException implements Exception {
  final String message;

  MedTrackException(this.message);

  @override
  String toString() {
    return message;
  }
}
