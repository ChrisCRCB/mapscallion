/// Useful int extensions.
extension IntX on int {
  /// Return a clock face.
  String get clockFace {
    final degrees = this % 360;
    final hour = (degrees / 30).round();
    return "${hour == 0 ? 12 : hour} o'clock";
  }
}
