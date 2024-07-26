import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/level.dart';
import 'package:shop/providers/home_provider.dart';
import 'package:shop/providers/user_provider.dart';
import 'package:shop/utils/constants.dart';
import 'package:shop/utils/format_utils.dart';
import 'package:shop/utils/level_utils.dart';
import 'package:shop/utils/math_utils.dart';

class LivesIndicator extends StatelessWidget {
  const LivesIndicator({Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    return GestureDetector(
      child: Consumer<UserProvider>(
        builder: (_, final UserProvider userProvider, __) {
          final int? livesCount = userProvider.user?.calculateLivesCount();
          final Level? level = LevelUtils.findLevel(livesCount);
          return Tooltip(
            message: level == null ? '' : 'Level:\n${level.title}',
            child: Row(
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: Icon(
                            Icons.local_gas_station,
                            size: 30,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            FormatUtils.formatInteger(livesCount) ?? '?',
                            style: const TextStyle(fontSize: 15),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: List.generate(Constants.maxLifeIconsCount,
                          (final int index) {
                        if (livesCount == null) {
                          return const Icon(
                            Icons.question_mark,
                            size: 20,
                            color: Colors.black12,
                          );
                        } else if (index <
                            MathUtils.ensureRange(
                                livesCount, 0, Constants.maxLifeIconsCount)) {
                          return const Icon(
                            Icons.water_drop,
                            size: 20,
                            color: Colors.amber,
                          );
                        } else {
                          return const Icon(
                            Icons.water_drop_outlined,
                            size: 20,
                            color: Colors.amber,
                          );
                        }
                      }),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
      onTap: () {
        final HomeProvider homeProvider = Provider.of<HomeProvider>(
          context,
          listen: false,
        );
        homeProvider.bottomNavigationBarIndex = 0;
      },
    );
  }
}
