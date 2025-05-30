import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class FormatDate {
  // inicializar o timezone e o dateformatting
  FormatDate() {
    tz.initializeTimeZones();
    initializeDateFormatting('de_DE');
  }

  DateTime parseBrazilianDateTime(String dateTimeStr) {
    return DateFormat('dd/MM/yyyy HH:mm:ss').parse(dateTimeStr);
  }

  // Formata a data e hora para o padrão brasileiro
  String formatDateAndTime(String dateTime, [String timeZone = 'America/Sao_Paulo']) {
    DateTime date = DateTime.parse(dateTime);
    Intl.defaultLocale = 'pt_BR';
    Intl.systemLocale = 'pt_BR';
    // pega o timezone
    final location = tz.getLocation(timeZone);
    // pega a data e hora
    final tzDateTime = tz.TZDateTime.from(date, location);
    // formata a data e hora
    String dateFormated = DateFormat.yMd().add_jm().format(tzDateTime);

    return dateFormated;
  }

  // Formata a data para o padrão brasileiro
  String formatDate(String date) {
    try {
      DateTime newDate = DateTime.parse(date);
      Intl.defaultLocale = 'pt_BR';
      Intl.systemLocale = 'pt_BR';

      String dateFormated = DateFormat.yMd().format(newDate);

      return dateFormated;
    } catch (e) {
      return date.replaceAll('-', '/');
    }
  }

  String formatDateWithTime(String date) {
    try {
      DateTime newDate = DateTime.parse(date);
      Intl.defaultLocale = 'pt_BR';
      Intl.systemLocale = 'pt_BR';

      String dateFormatted = DateFormat('dd/MM/yyyy HH:mm:ss').format(newDate);

      return dateFormatted;
    } catch (e) {
      return date.replaceAll('-', '/');
    }
  }

  // Formata a data e adiciona anos
  String formatDateAndAddYears(String date, {num yearsToAdd = 0}) {
    try {
      DateTime newDate = DateTime.parse(date);

      newDate = DateTime(newDate.year + yearsToAdd.toInt(), newDate.month, newDate.day);

      Intl.defaultLocale = 'pt_BR';
      Intl.systemLocale = 'pt_BR';

      String dateFormatted = DateFormat.yMd().format(newDate);

      return dateFormatted;
    } catch (e) {
      return '';
    }
  }

  // Formata a data do padrão brasileiro ou americano para o padrão americano
  // função utilizada quando não se sabe o formato da data (brasil ou americano)
  String datesBrAndUS(String date) {
    if (date.isNotEmpty) {
      DateTime dateFormat;

      if (date.contains('-')) {
        dateFormat = DateFormat('yyyy-MM-dd').parse(date);
      } else if (date.contains('/')) {
        dateFormat = DateFormat('dd/MM/yyyy').parse(date);
      } else {
        throw const FormatException('Formato de data inválido');
      }

      return DateFormat('yyyy-MM-dd').format(dateFormat);
    } else {
      return '';
    }
  }

  // Formata a data do padrão brasileiro para o padrão americano
  String formatStringDateForAmericanStandard(String date) {
    if (date.isNotEmpty) {
      if (date.length == 10) {
        var dateFormat = DateFormat('dd/MM/yyyy').parse(date);

        return DateFormat('yyyy-MM-dd').format(dateFormat);
      } else {
        return date.replaceAll('/', '-');
      }
    } else {
      return '';
    }
  }

  // Formata uma data em string do padrão americano para DateTime brasileiro
  DateTime formatStringForDateTime(String date) {
    if (date.length <= 9) {
      return DateTime.now();
    } else if (DateFormat('dd/MM/yyyy').parse(date).year > 2099) {
      return DateFormat('dd/MM/yyyy').parse('2099-01-01');
    } else {
      return DateFormat('dd/MM/yyyy').parse(date);
    }
  }

  // Formata uma data em string do padrão brasileiro para DateTime
  DateTime formatStringForDateTimeWithDash(String date) {
    return DateFormat('dd-MM-yyyy').parse(date);
  }

  // Formata uma data em string do padrão dia - mes - ano para DateTime com barra
  DateTime formatStringWithBarForDateTimeWithDash(String date) {
    var dateFormat = DateFormat('dd/MM/yyyy').parse(date);
    var dateNew = DateFormat('dd-MM-yyyy').format(dateFormat);
    return DateFormat('dd-MM-yyyy').parse(dateNew);
  }

  // pega a data de amanha
  String getTomorrowDate() {
    return DateFormat('yyyy-MM-dd').format(DateTime.now().add(const Duration(days: 1)));
  }

  // comparação de datas em string e retorna um boolean
  bool compareDateStrings(String dateString1, String dateString2) {
    /**
     * comparação de datas
     * exemplo: 
     * dateString1 = '10/01/2024'
     * dateString2 = '1999-01-31'
     */

    if (dateString1.length <= 9 || dateString2.length <= 9) {
      return true;
    }

    var date = FormatDate().formatDate(dateString2);
    DateTime date1 = DateFormat('dd/MM/yyyy').parse(dateString1);
    DateTime date2 = DateFormat('dd/MM/yyyy').parse(date);
    return date1.isBefore(date2);
  }

  // Formata a data com a mascara dd/MM/yyyy
  String formatDateWithOnChange(String value) {
    // Remove tudo que não é dígito
    value = value.replaceAll(RegExp(r'\D'), '');

    return value.replaceAllMapped(
      RegExp(r'^(\d{1,2})(\d{0,2})?(\d{0,4})?$'),
      (Match m) {
        if (m[3] != null) {
          return '${m[1]}/${m[2]}/${m[3]}';
        } else if (m[2] != null) {
          return '${m[1]}/${m[2]}';
        } else {
          return m[1]!;
        }
      },
    );
  }

  // Formata o tempo com a máscara HH:mm:ss
// Formata uma string para o padrão dd/MM/yyyy HH:mm:ss conforme o usuário digita
  String formatDateTimeWithOnChange(String value) {
    // Remove tudo que não é dígito
    value = value.replaceAll(RegExp(r'\D'), '');

    return value.replaceAllMapped(
      RegExp(r'^(\d{1,2})(\d{0,2})?(\d{0,4})?(\d{0,2})?(\d{0,2})?(\d{0,2})?$'),
      (Match m) {
        String result = '';

        if (m[1] != null) result += m[1]!;
        if (m[2] != null && m[2]!.isNotEmpty) result += '/${m[2]}';
        if (m[3] != null && m[3]!.isNotEmpty) result += '/${m[3]}';
        if (m[4] != null && m[4]!.isNotEmpty) result += ' ${m[4]}';
        if (m[5] != null && m[5]!.isNotEmpty) result += ':${m[5]}';
        if (m[6] != null && m[6]!.isNotEmpty) result += ':${m[6]}';

        return result;
      },
    );
  }

  /// Recebe um Timestamp do Firestore e retorna a data formatada no padrão brasileiro com horário
  String formatFirestoreTimestamp(Timestamp timestamp, [String timeZone = 'America/Sao_Paulo']) {
    // Converte Timestamp para DateTime UTC
    DateTime dateUtc = timestamp.toDate().toUtc().add(const Duration(hours: 3));

    Intl.defaultLocale = 'pt_BR';

    // Pega o timezone
    final location = tz.getLocation(timeZone);

    // Converte para timezone local
    final tzDateTime = tz.TZDateTime.from(dateUtc, location);

    // Formata para dd/MM/yyyy HH:mm
    String formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(tzDateTime);

    return formattedDate;
  }
}
