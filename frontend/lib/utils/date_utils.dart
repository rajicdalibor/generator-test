import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

const dateFormat = 'dd.MM.yyyy';

String? formatDateToIso(String birthDate, String format) {
  try {
    final DateTime parsedDate = DateFormat(format).parse(birthDate);
    return parsedDate.toIso8601String();
  } catch (e) {
    debugPrint('Error parsing birthDate: $e');
    return null;
  }
}

String? validateDate(String? date, AppLocalizations translations) {
  if (date != null && date.isEmpty) {
    return translations.dateIsEmptyError;
  }
  return null;
}
