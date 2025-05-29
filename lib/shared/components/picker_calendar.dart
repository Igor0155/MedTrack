import 'package:flutter/material.dart';
import 'package:meditrack/shared/helpers/format_date.dart';

class PickerCalendar {
  FormatDate formatDate = FormatDate();

  Future<DateTime?> pickerCalendar({
    required BuildContext context,
    required TextEditingController controller,
    bool isTime = false,
    String firstDate = '1900-01-01',
  }) async {
    DateTime? initialDate;
    //quando o campo já vem com data
    if (controller.text.isNotEmpty) {
      initialDate = formatDate.formatStringForDateTime(controller.text);
      var compare = formatDate.compareDateStrings(controller.text, firstDate);
      if (compare) {
        initialDate = null;
      }
    }

    final DateTime? pickedDate = await showDatePicker(
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      initialDate: initialDate ?? DateTime.now(),
      barrierDismissible: false,
      locale: const Locale('pt'),
      helpText: 'Escolha a data',
      confirmText: 'Confirmar',
      cancelText: 'Cancelar',
      context: context,
      firstDate: DateTime.parse(firstDate),
      lastDate: DateTime.parse('2099-12-31'),
    );

    if (pickedDate == null) return null;

    if (!isTime) {
      return pickedDate;
    }
    if (!context.mounted) return null;

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialDate ?? DateTime.now()),
      helpText: 'Escolha a hora',
      confirmText: 'Confirmar',
      cancelText: 'Cancelar',
    );

    if (pickedTime == null) return null;

    return DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );
  }
}
