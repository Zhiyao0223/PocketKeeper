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
  String getMonthString() {
    switch (this.toInt()) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return '';
    }
  }
}
