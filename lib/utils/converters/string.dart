extension StringExtension on String {
  // Convert to DateTime
  DateTime toDateTime() {
    String modifiedString = replaceFirst(' ', 'T');
    return DateTime.parse(modifiedString);
  }
}
