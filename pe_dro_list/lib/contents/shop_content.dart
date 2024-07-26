import 'package:flutter/material.dart';
import 'package:shop/components/shop_item_card.dart';
import 'package:shop/models/shop_item.dart';
import 'package:shop/utils/constants.dart';

class ShopContent extends StatelessWidget {
  const ShopContent({Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    const List<ShopItem> items = Constants.shopItems;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ListView.builder(
        itemBuilder: (context, index) {
          return ShopItemCard(items[index]);
        },
        itemCount: items.length,
      ),
    );
  }
}
