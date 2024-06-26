import 'package:intl/intl.dart';

extension DateExtension on DateTime {
  // Convert to string
  String toDateString({String? dateFormat}) {
    return dateFormat != null
        ? DateFormat(dateFormat).format(this)
        : toIso8601String().split('T').first;
  }

  // Convert to time
  String toTimeString() {
    return toIso8601String().split('T').last;
  }

  // Convert to date and time
  String toDateTimeString() {
    return toIso8601String().replaceAll('T', ' ');
  }
}
