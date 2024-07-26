import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/image_toast.dart';
import 'package:shop/models/level.dart';
import 'package:shop/models/life_package.dart';
import 'package:shop/models/shop_item.dart';
import 'package:shop/providers/home_provider.dart';
import 'package:shop/providers/user_provider.dart';
import 'package:shop/utils/app_logger.dart';
import 'package:shop/utils/constants.dart';
import 'package:shop/utils/level_utils.dart';
import 'package:shop/utils/list_utils.dart';

class ShopItemCard extends StatelessWidget {
  ShopItemCard(this.item, {Key? key}) : super(key: key);

  final ShopItem item;
  final FToast _fToast = FToast();

  @override
  Widget build(final BuildContext context) {
    _fToast.init(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 0,
      ),
      child: GestureDetector(
        child: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Theme.of(context).colorScheme.tertiary,
              width: 3,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(
                  width: 80,
                  height: 80,
                  child: Image(
                    image: AssetImage(item.imageAssetName),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          item.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          item.description,
                          style: const TextStyle(
                            color: Color.fromRGBO(63, 63, 63, 1),
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Consumer<UserProvider>(
                          builder: (_, final UserProvider userProvider, __) {
                            final int? coinsCount =
                                userProvider.user?.coinsCount;
                            if (coinsCount == null ||
                                coinsCount >= item.priceInCoins) {
                              return Text(
                                '${item.priceInCoins.toString()} coins',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 18,
                                ),
                              );
                            } else {
                              final int coinsLeftCount =
                                  item.priceInCoins - coinsCount;
                              return Text(
                                '${(coinsLeftCount).toString()} coins left!',
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontSize: 18,
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        onTap: () => _confirmPurchase(context),
      ),
    );
  }

  void _confirmPurchase(final BuildContext context) {
    if (item is! LifePackage) {
      return;
    }
    final UserProvider userProvider = Provider.of<UserProvider>(
      context,
      listen: false,
    );
    final int? coinsCount = userProvider.user?.coinsCount;
    if (coinsCount == null || coinsCount < item.priceInCoins) {
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Padding(
            padding: const EdgeInsets.only(top: 10),
            child:
                Text('The ${item.title} will cost ${item.priceInCoins} coins.'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.secondary,
              ),
              child: const Text('Lemme think some more...'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _buyItem(context);
              },
              child: const Text('Alright! I want to buy it!'),
            ),
          ],
          backgroundColor: Colors.white,
        );
      },
    );
  }

  void _buyItem(final BuildContext context) async {
    final HomeProvider homeProvider = Provider.of<HomeProvider>(
      context,
      listen: false,
    );
    if (homeProvider.isProcessing) {
      return;
    }
    _showInformationToast(context);
    final UserProvider userProvider = Provider.of<UserProvider>(
      context,
      listen: false,
    );
    homeProvider.isProcessing = true;
    try {
      await userProvider.buyLifePackage(item as LifePackage);
    } catch (e) {
      logger.e(e);
      _showErrorToast();
    } finally {
      homeProvider.isProcessing = false;
    }
  }

  void _showInformationToast(final BuildContext context) {
    final Level? level = _findLevel(context);
    if (level == null) {
      return;
    }
    _fToast.showToast(
      child: ImageToast(
        imageAssetName: ListUtils.getRandom(level.imageAssetNames),
        text: '${ListUtils.getRandom(Constants.livesCountIncreaseMessages)}' +
            '\n${level.message}',
      ),
      toastDuration: Constants.toastDuration,
      gravity: ToastGravity.CENTER,
    );
  }

  Level? _findLevel(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(
      context,
      listen: false,
    );
    final int? livesCount = userProvider.user?.calculateLivesCount();
    final int? newLivesCount = livesCount == null
        ? null
        : livesCount + (item as LifePackage).livesCount;
    return LevelUtils.findLevel(newLivesCount);
  }

  void _showErrorToast() {
    _fToast.showToast(
      child: ImageToast(
        imageAssetName: ListUtils.getRandom(Constants.errorImageAssetNames),
        text: 'It was not possible to buy the item. Please try again later.',
        type: ImageToastType.error,
      ),
      toastDuration: Constants.toastDuration,
      gravity: ToastGravity.CENTER,
    );
  }
}
