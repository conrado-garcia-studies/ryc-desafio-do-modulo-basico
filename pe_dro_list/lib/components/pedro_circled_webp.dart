import 'package:flutter/material.dart';

class PedroCircledWebp extends StatelessWidget {
  const PedroCircledWebp({
    Key? key,
    required this.isIncludesPedro,
    required this.fps,
  }) : super(key: key);

  final bool isIncludesPedro;
  final int fps;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundImage: AssetImage(
          'assets/images/avatars/with${isIncludesPedro ? '' : 'out'}_pedro_$fps' +
              '_fps.webp'),
      radius: 56,
    );
  }
}
