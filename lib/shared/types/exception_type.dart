class MediTrackException implements Exception {
  final String message;

  MediTrackException(this.message);

  @override
  String toString() {
    return message;
  }
}
