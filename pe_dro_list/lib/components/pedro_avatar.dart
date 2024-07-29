import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/pedro_circled_webp.dart';
import 'package:shop/components/with_pedro_sprite.dart';
import 'package:shop/components/without_pedro_sprite.dart';
import 'package:shop/providers/user_provider.dart';
import 'package:shop/utils/constants.dart';

class PedroAvatar extends StatelessWidget {
  const PedroAvatar({Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    return Consumer<UserProvider>(
      builder: (_, final UserProvider userProvider, __) {
        final int? livesCount = userProvider.calculateLivesCount();
        final bool isIncludesPedro = livesCount != null &&
            livesCount >= Constants.minLivesCountForPedroToAppear;
        return _createPedroWidget(isIncludesPedro);
      },
    );
  }

  Widget _createPedroWidget(final bool isIncludesPedro) {
    if (Constants.avatarType == PedroAvatarType.spriteWith25Fps) {
      if (isIncludesPedro) {
        return _createPaddedCircle(
          const WithPedroSprite(),
        );
      }
      return _createPaddedCircle(
        const WithoutPedroSprite(),
      );
    }
    if (Constants.avatarType == PedroAvatarType.webpWith12Fps) {
      return PedroCircledWebp(
        isIncludesPedro: isIncludesPedro,
        fps: 12,
      );
    }
    if (Constants.avatarType == PedroAvatarType.webpWith30Fps) {
      return PedroCircledWebp(
        isIncludesPedro: isIncludesPedro,
        fps: 30,
      );
    }
    return const SizedBox(
      width: 112,
    );
  }

  Padding _createPaddedCircle(final Widget child) {
    return Padding(
      padding: const EdgeInsets.all(1),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(55),
        child: child,
      ),
    );
  }
}

enum PedroAvatarType { spriteWith25Fps, webpWith12Fps, webpWith30Fps }
