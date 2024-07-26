import 'package:shop/models/shop_item.dart';

class LifePackage extends ShopItem {
  const LifePackage({
    imageAssetName,
    title,
    description,
    priceInCoins,
    required this.livesCount,
  }) : super(
            imageAssetName: imageAssetName,
            title: title,
            description: description,
            priceInCoins: priceInCoins);

  final int livesCount;
}
