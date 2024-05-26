/*
  Compare Int range.
  Return true if the int is between min and max
  */
bool validateIntRange(
    {required double number, required double min, required double max}) {
  return number >= min && number <= max;
}

/*
  Check if decimal number is within two decimal points
  */
bool validateDecimalTwoPoints(String? value) {
  final RegExp regExp = RegExp(r'^\d*\.?\d{0,2}$');

  // If the input doesn't match the pattern, revert to the old value
  return (!regExp.hasMatch(value!)) ? false : true;
}
