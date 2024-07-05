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
}
