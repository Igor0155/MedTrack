String formatDosageByType({required String dosage, required String formFarm}) {
  var descriptionDosage = '';

  switch (formFarm) {
    case 'CMP':
    case 'CAP':
      descriptionDosage = "$dosage  mg";
      break;
    case 'SOL':
    case 'INJ':
      descriptionDosage = "$dosage  ml";
      break;
    case 'OUT':
    default:
      descriptionDosage = dosage;
      break;
  }

  return descriptionDosage;
}
