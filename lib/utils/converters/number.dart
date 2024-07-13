/*
Provide universal method to convert to number
*/

extension NumberExtension on num {
  String toInt() {
    return toStringAsFixed(0);
  }

  String toCurrency(double value) {
    return value.toStringAsFixed(2);
  }

  String toCommaSeparated() {
    return removeExtraDecimal().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  }

  // Convert double to whole number if no decimal
  String removeExtraDecimal() {
    // Only convert to no decimal if it is whole number
    return (this % 1 == 0) ? toStringAsFixed(0) : toStringAsFixed(2);
  }

  // Round off to whole number
  String toWholeNumber() {
    return round().toString();
  }

  // This function convert numeric month to string
  String toMonthString([bool isShort = false]) {
    switch (this.toInt()) {
      case 1:
        return (isShort) ? 'Jan' : 'January';
      case 2:
        return (isShort) ? 'Feb' : 'February';
      case 3:
        return (isShort) ? 'Mar' : 'March';
      case 4:
        return (isShort) ? 'Apr' : 'April';
      case 5:
        return (isShort) ? 'May' : 'May';
      case 6:
        return (isShort) ? 'Jun' : 'June';
      case 7:
        return (isShort) ? 'Jul' : 'July';
      case 8:
        return (isShort) ? 'Aug' : 'August';
      case 9:
        return (isShort) ? 'Sep' : 'September';
      case 10:
        return (isShort) ? 'Oct' : 'October';
      case 11:
        return (isShort) ? 'Nov' : 'November';
      case 12:
        return (isShort) ? 'Dec' : 'December';
      default:
        return '';
    }
  }
}
