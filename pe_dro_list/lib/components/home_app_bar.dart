import 'package:flutter/material.dart';
import 'package:shop/components/coins_indicator.dart';
import 'package:shop/components/home_actions.dart';
import 'package:shop/components/lives_indicator.dart';
import 'package:shop/components/pedro_avatar.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize {
    return const Size.fromHeight(140);
  }

  @override
  Widget build(final BuildContext context) {
    return AppBar(
      title: const Row(
        children: <Widget>[
          PedroAvatar(),
          SizedBox(
            width: 22.9,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CoinsIndicator(),
              SizedBox(
                height: 12,
              ),
              LivesIndicator(),
            ],
          ),
        ],
      ),
      actions: const <Widget>[
        HomeActions(),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(3),
        child: Container(
          color: Theme.of(context).colorScheme.tertiary,
          height: 3,
        ),
      ),
      shadowColor: Theme.of(context).colorScheme.primary,
      backgroundColor: Colors.white,
      centerTitle: false,
      titleSpacing: 0,
      toolbarHeight: 140,
    );
  }
}
