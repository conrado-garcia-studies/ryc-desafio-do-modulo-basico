import 'package:flutter/material.dart';
import 'package:shop/components/pedro_sprite.dart';

class WithPedroSprite extends PedroSprite {
  const WithPedroSprite({Key? key}) : super(key: key, isIncludesPedro: true);

  @override
  PedroSpriteState createState() => _WithPedroSpriteState();
}

class _WithPedroSpriteState<T extends PedroSpriteState>
    extends PedroSpriteState {}
