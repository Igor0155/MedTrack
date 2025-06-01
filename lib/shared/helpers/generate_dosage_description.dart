String generateDosageDescription({
  required String dosage,
  required int dosageIntervalHours,
  required String pharmaceuticalForm,
  required int durationDays,
}) {
  final dosageParts = dosage.split(' ');
  final unit = dosageParts.last;
  final amount = dosageParts.length > 1 ? dosageParts.first : '1';

  final intervalDescription = dosageIntervalHours > 0 ? 'a cada $dosageIntervalHours horas' : 'uma vez ao dia';

  final formDescription = pharmaceuticalForm.isNotEmpty ? 'em forma de $pharmaceuticalForm' : '';

  final durationDescription = durationDays > 0 ? 'durante $durationDays dias' : '';

  return '$amount $unit $formDescription, $intervalDescription $durationDescription.';
}
