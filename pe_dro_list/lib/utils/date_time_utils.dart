import 'package:jiffy/jiffy.dart';

class DateTimeUtils {
  static DateTime getEndOfDay(final DateTime dateTime) {
    return Jiffy.parseFromDateTime(dateTime).endOf(Unit.day).dateTime;
  }
}
