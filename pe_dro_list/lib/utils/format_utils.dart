import 'package:intl/intl.dart';

class FormatUtils {
  static const int _firstTooBigNumber = 100000;
  static const int _lastTooSmallNumber = -1 * _firstTooBigNumber;
  static const String _languageCode = 'en';
  static final NumberFormat _regularFormat =
      NumberFormat.decimalPattern(_languageCode);
  static final NumberFormat _exceptionalFormat =
      NumberFormat.decimalPattern(_languageCode);

  static String? formatInteger(final int? value) {
    if (value == null) {
      return null;
    }
    final NumberFormat numberFormat =
        value > _lastTooSmallNumber && value < _firstTooBigNumber
            ? _regularFormat
            : _exceptionalFormat;
    return numberFormat.format(value);
  }
}
