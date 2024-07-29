import 'package:flutter/material.dart';
import 'package:shop/components/pedro_sprite.dart';

class WithoutPedroSprite extends PedroSprite {
  const WithoutPedroSprite({Key? key})
      : super(key: key, isIncludesPedro: false);

  @override
  PedroSpriteState createState() => _WithoutPedroSpriteState();
}

class _WithoutPedroSpriteState<T extends PedroSpriteState>
    extends PedroSpriteState {}
