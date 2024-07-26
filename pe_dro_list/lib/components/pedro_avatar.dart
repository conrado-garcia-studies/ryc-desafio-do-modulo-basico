import 'package:flutter/material.dart';

class PedroAvatar extends StatelessWidget {
  const PedroAvatar({
    Key? key,
    required this.withPedro,
    required this.fps,
  }) : super(key: key);

  final bool withPedro;
  final int fps;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundImage: AssetImage(
          'assets/images/avatars/with${withPedro ? '' : 'out'}_pedro_$fps' +
              '_fps.webp'),
      radius: 56,
    );
  }
}
