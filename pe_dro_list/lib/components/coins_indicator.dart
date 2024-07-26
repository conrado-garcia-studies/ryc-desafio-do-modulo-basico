import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/home_provider.dart';
import 'package:shop/providers/user_provider.dart';
import 'package:shop/utils/format_utils.dart';

class CoinsIndicator extends StatelessWidget {
  const CoinsIndicator({Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    return GestureDetector(
      child: Row(
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(right: 5),
            child: Stack(
              children: <Widget>[
                Icon(
                  Icons.monetization_on,
                  size: 30,
                  color: Color.fromARGB(255, 240, 171, 27),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Icon(
                    Icons.monetization_on_outlined,
                    size: 30,
                    color: Color.fromARGB(255, 247, 205, 78),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Consumer<UserProvider>(
              builder: (_, final UserProvider userProvider, __) => Text(
                FormatUtils.formatInteger(userProvider.user?.coinsCount) ?? '?',
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 15),
              ),
            ),
          ),
        ],
      ),
      onTap: () {
        final HomeProvider homeProvider = Provider.of<HomeProvider>(
          context,
          listen: false,
        );
        homeProvider.bottomNavigationBarIndex = 1;
      },
    );
  }
}
