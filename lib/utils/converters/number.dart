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
    return toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  }

  // Convert double to whole number if no decimal
  String toWholeNumber(double tempTotal) {
    // Only convert to no decimal if it is whole number
    return (tempTotal % 1 == 0)
        ? tempTotal.toStringAsFixed(2)
        : tempTotal.toStringAsFixed(2);
  }
}
