import 'package:meditrack/shared/helpers/format_date.dart';

typedef StringValidationCallback = String? Function(String? value);

class FormValidationBuilder {
  final bool isOptional;
  final List<StringValidationCallback> validations = [];

  FormValidationBuilder({this.isOptional = false});

  FormValidationBuilder add(StringValidationCallback validator) {
    validations.add(validator);
    return this;
  }

  String? test(String? value) {
    for (var validate in validations) {
      if (isOptional && (value == null || value.isEmpty)) {
        return null;
      }

      final result = validate(value);

      if (result != null) {
        return result;
      }
    }
    return null;
  }

  StringValidationCallback build() => test;
}

extension CustomValidationBuild on FormValidationBuilder {
  FormValidationBuilder required() {
    return add((value) => value == null || value.isEmpty ? 'Campo obrigatório' : null);
  }

  FormValidationBuilder minLength(int length, [String? message]) {
    return add((value) =>
        value != null && value.length < length ? message ?? 'Campo deve ter no mínimo $length caracteres' : null);
  }

  FormValidationBuilder maxLength(int length, [String? message]) {
    return add((value) =>
        value != null && value.length > length ? message ?? 'Campo deve ter no máximo $length caracteres' : null);
  }

  FormValidationBuilder email([String? message]) {
    return add((value) {
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      return value != null && !emailRegex.hasMatch(value) ? message ?? 'Email inválido' : null;
    });
  }

  FormValidationBuilder date([String? message]) {
    return add((value) {
      final dateRegex = RegExp(r'^\d{2}/\d{2}/\d{4}$');
      if (value == null || value.isEmpty) return null;
      return value.length != 10 || !dateRegex.hasMatch(value)
          ? message ?? 'Data inválida, use o formato DD/MM/AAAA'
          : null;
    });
  }

  FormValidationBuilder dateTime([String? message]) {
    return add((value) {
      // Expressão regular para DD/MM/AAAA HH:MM:SS
      final dateTimeRegex = RegExp(r'^(0[1-9]|[12][0-9]|3[01])/(0[1-9]|1[0-2])/\d{4} ' // Data
          r'([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]$' // Hora
          );

      if (value == null || value.isEmpty) return null;

      return !dateTimeRegex.hasMatch(value)
          ? message ?? 'Data e hora inválidas, use o formato DD/MM/AAAA HH:MM:SS'
          : null;
    });
  }

  FormValidationBuilder isRequiredWhenBothFieldsAreEmpty(List<String> valueToCompare1, List<String> valueToCompare2,
      [String? message]) {
    return add((value) {
      if (valueToCompare1.isEmpty && valueToCompare2.isEmpty) {
        return message ?? 'É obrigatório o preenchimento de um dos dois campos';
      } else {
        return null;
      }
    });
  }

  FormValidationBuilder isRequiredWhenBothFieldsAreEmptyAndEmailNotRequired(
      List<String> valueToCompare1, List<String> valueToCompare2,
      [String? message]) {
    return add((value) {
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (value != null && value.isNotEmpty && !emailRegex.hasMatch(value)) {
        return message ?? 'Email inválido';
      } else if (value != null && value.isNotEmpty && emailRegex.hasMatch(value)) {
        return null;
      }
      if (valueToCompare1.isEmpty && valueToCompare2.isEmpty) {
        return message ?? 'É obrigatório o preenchimento de um dos dois campos';
      } else {
        return null;
      }
    });
  }

  FormValidationBuilder emailNotRequired([String? message]) {
    return add((value) {
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      return value != null && value != "" && !emailRegex.hasMatch(value) ? message ?? 'Email inválido' : null;
    });
  }

  FormValidationBuilder notEqual(String valueToCompare, [String? message]) {
    return add((value) => value == valueToCompare ? message ?? 'O campo não pode ser igual' : null);
  }

  FormValidationBuilder equal(String valueToCompare, [String? message]) {
    return add((value) => value != valueToCompare ? message ?? 'O campo não pode ser diferente' : null);
  }

  FormValidationBuilder notSmallerDate(DateTime valueToCompareDateOriginal, [String? message]) {
    return add((value) {
      DateTime? expurgeDate = FormatDate().formatStringForDateTime(value!);
      if (expurgeDate.isBefore(valueToCompareDateOriginal)) {
        return message ?? 'A data não pode ser anterior a outra.';
      } else {
        return null;
      }
    });
  }
}
