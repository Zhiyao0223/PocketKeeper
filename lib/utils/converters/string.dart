import 'package:intl/intl.dart';

extension StringExtension on String {
  // Convert to DateTime
  DateTime toDateTime() {
    String modifiedString = replaceFirst(' ', 'T');
    return DateTime.parse(modifiedString);
  }

  // Capitalize the first letter of the string
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }

  DateTime? tryParseDateTime(String dateFormat) {
    try {
      return DateFormat(dateFormat).parse(this);
    } catch (e) {
      return null;
    }
  }
}
