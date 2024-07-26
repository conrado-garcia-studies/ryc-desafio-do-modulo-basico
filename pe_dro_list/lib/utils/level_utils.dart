import 'package:shop/models/level.dart';
import 'package:shop/utils/constants.dart';

class LevelUtils {
  static Level? findLevel(final int? livesCount) {
    if (livesCount == null) {
      return null;
    }
    return Constants.levels
        .where((level) =>
            livesCount >= level.minLivesCount &&
            livesCount <= level.maxLivesCount)
        .first;
  }
}
