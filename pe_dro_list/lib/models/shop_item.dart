class ShopItem {
  const ShopItem({
    required this.imageAssetName,
    required this.title,
    required this.description,
    required this.priceInCoins,
  });

  final String imageAssetName;
  final String title;
  final String description;
  final int priceInCoins;
}
