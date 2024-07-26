import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/coins_indicator.dart';
import 'package:shop/components/lives_indicator.dart';
import 'package:shop/components/pedro_avatar.dart';
import 'package:shop/components/play_button.dart';
import 'package:shop/providers/home_provider.dart';
import 'package:shop/providers/user_provider.dart';
import 'package:shop/utils/constants.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize {
    return const Size.fromHeight(140);
  }

  @override
  Widget build(final BuildContext context) {
    return AppBar(
      title: Row(
        children: <Widget>[
          Consumer<UserProvider>(
            builder: (_, final UserProvider userProvider, __) {
              final int? livesCount = userProvider.user?.calculateLivesCount();
              return PedroAvatar(
                withPedro: livesCount != null &&
                    livesCount >= Constants.minLivesCountForPedroToAppear,
                fps: 12,
              );
            },
          ),
          const SizedBox(
            width: 22.9,
          ),
          const Column(
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
      actions: <Widget>[
        const PlayButton(),
        Consumer<HomeProvider>(
          builder: (_, final HomeProvider homeProvider, __) {
            if (homeProvider.subcontent == null) {
              return const SizedBox(
                width: 48,
              );
            }
            return IconButton(
              onPressed: () => _goBack(context),
              icon: const Icon(
                Icons.chevron_left,
                size: 32,
              ),
            );
          },
        ),
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

  void _goBack(final BuildContext context) {
    final HomeProvider homeProvider = Provider.of<HomeProvider>(
      context,
      listen: false,
    );
    homeProvider.subcontent = null;
  }
}
