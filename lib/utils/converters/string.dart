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

  // Convert to month
  int toMonthInt() {
    switch (this) {
      case 'Jan':
      case 'January':
        return 1;
      case 'Feb':
      case 'February':
        return 2;
      case 'Mar':
      case 'March':
        return 3;
      case 'Apr':
      case 'April':
        return 4;
      case 'May':
        return 5;
      case 'Jun':
      case 'June':
        return 6;
      case 'Jul':
      case 'July':
        return 7;
      case 'Aug':
      case 'August':
        return 8;
      case 'Sep':
      case 'September':
        return 9;
      case 'Oct':
      case 'October':
        return 10;
      case 'Nov':
      case 'November':
        return 11;
      case 'Dec':
      case 'December':
        return 12;
    }
    return 0;
  }
}
