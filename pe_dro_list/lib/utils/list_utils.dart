import 'dart:math';

class ListUtils {
  static getRandom(final List<dynamic> list) {
    return list[Random().nextInt(list.length)];
  }
}
