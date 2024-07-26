import 'dart:math';

class MathUtils {
  static int ensureRange(int value, int? minValue, int? maxValue) {
    if (minValue == null && maxValue != null) {
      return min(value, maxValue);
    }
    if (minValue != null && maxValue == null) {
      return max(value, minValue);
    }
    if (minValue != null && maxValue != null) {
      return min(max(value, minValue), maxValue);
    }
    return value;
  }
}
