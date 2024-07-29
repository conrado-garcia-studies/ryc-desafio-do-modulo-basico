import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/play_button.dart';
import 'package:shop/providers/home_provider.dart';

class HomeActions extends StatelessWidget {
  const HomeActions({Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (_, final HomeProvider homeProvider, __) {
        if (homeProvider.subcontent == null) {
          return const Padding(
            padding: EdgeInsets.only(right: 3),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                PlayButton(),
              ],
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.only(right: 3),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const PlayButton(),
              IconButton(
                onPressed: () => _goBack(context),
                icon: const Icon(
                  Icons.chevron_left,
                  size: 32,
                ),
              ),
            ],
          ),
        );
      },
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
