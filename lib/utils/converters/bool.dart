extension BoolExtension on bool {
  int toInt() {
    return this ? 1 : 0;
  }

  double toDouble() {
    return this ? 1.0 : 0.0;
  }

  String customToString() {
    return this ? 'true' : 'false';
  }
}
