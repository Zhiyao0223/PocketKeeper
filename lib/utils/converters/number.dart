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

  String toCurrencyWithSymbol() {
    return '\$${toStringAsFixed(2)}';
  }

  String toCurrencyWithSymbolAndDecimal() {
    return '\$${toStringAsFixed(2)}';
  }

  String toPercentage() {
    return '${toStringAsFixed(2)}%';
  }

  String toPercentageWithSymbol() {
    return '${toStringAsFixed(2)}%';
  }

  String toPercentageWithSymbolAndDecimal() {
    return '${toStringAsFixed(2)}%';
  }

  String toCommaSeparated() {
    return toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  }

  String toCommaSeparatedWithSymbol() {
    return '\$${toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
  }

  String toCommaSeparatedWithSymbolAndDecimal() {
    return '\$${toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
  }

  String toCommaSeparatedWithDecimal() {
    return toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  }
}
