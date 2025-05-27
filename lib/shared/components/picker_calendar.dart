import 'package:flutter/material.dart';
import 'package:meditrack/shared/helpers/format_date.dart';

class PickerCalendar {
  FormatDate formatDate = FormatDate();

  Future<DateTime?> pickerCalendar({
    required BuildContext context,
    required TextEditingController controller,
    String firstDate = '1900-01-01',
  }) async {
    DateTime? initialDate;
    //quando o campo já vem com data
    if (controller.text.isNotEmpty) {
      //data inicial vai vir marcando a data do campo
      initialDate = formatDate.formatStringForDateTime(controller.text);
      //comparação para ver se a data initial é menor que a primeira data
      var compare = formatDate.compareDateStrings(controller.text, firstDate);
      if (compare) {
        initialDate = null;
      }
    }
    return await showDatePicker(
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        initialDate: initialDate,
        barrierDismissible: false,
        locale: const Locale('pt'),
        helpText: 'Escolha a data',
        confirmText: 'Confirmar',
        cancelText: 'Cancelar',
        context: context,
        firstDate: DateTime.parse(firstDate),
        lastDate: DateTime.parse('2099-12-31'));
  }
}
