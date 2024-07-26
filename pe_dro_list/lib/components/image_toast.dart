import 'package:flutter/material.dart';

class ImageToast extends StatelessWidget {
  const ImageToast({
    Key? key,
    required this.imageAssetName,
    required this.text,
    this.type = ImageToastType.information,
  }) : super(key: key);

  final String imageAssetName;
  final String text;
  final ImageToastType type;

  @override
  Widget build(final BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: type == ImageToastType.error ? Colors.red : Colors.white,
        border: Border.all(
          color: Theme.of(context).colorScheme.tertiary,
          width: 3,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image(
                image: AssetImage(
                  imageAssetName,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(text),
          ),
        ],
      ),
    );
  }
}

enum ImageToastType {
  error,
  information,
}
