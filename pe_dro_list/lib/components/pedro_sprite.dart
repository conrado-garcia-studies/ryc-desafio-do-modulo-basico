import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sprite/animation_painter.dart';

class PedroSprite extends StatefulWidget {
  const PedroSprite({
    Key? key,
    required this.isIncludesPedro,
  }) : super(key: key);

  final bool isIncludesPedro;

  @override
  State<PedroSprite> createState() => PedroSpriteState();
}

class PedroSpriteState extends State<PedroSprite> {
  ui.Image? _loadedImage;
  Timer? _animationTimer;
  static const double _squareImageWidth = 110;
  late int _horizontalAxisProcessingMatrixColumnsCount;
  late int _horizontalAxisProcessingMatrixLastRowColumnsCount;
  late int _horizontalAxisProcessingMatrixRowsCount;
  late int _verticalAxisProcessingColumnRowsCount;
  int _column = 1;
  int _row = 1;

  @override
  void initState() {
    super.initState();
    _horizontalAxisProcessingMatrixColumnsCount =
        widget.isIncludesPedro ? 28 : 12;
    _horizontalAxisProcessingMatrixLastRowColumnsCount =
        widget.isIncludesPedro ? 28 : 5;
    _horizontalAxisProcessingMatrixRowsCount = widget.isIncludesPedro ? 28 : 13;
    _verticalAxisProcessingColumnRowsCount = widget.isIncludesPedro ? 19 : 12;
    _init();
  }

  _init() async {
    await _loadImage();
    await _setTimer();
  }

  _loadImage() async {
    final data = await rootBundle.load(
        'assets/images/avatars/with${widget.isIncludesPedro ? '' : 'out'}' +
            '_pedro_25_fps_spritesheet.png');
    final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    final frame = await codec.getNextFrame();
    setState(() {
      _loadedImage = frame.image;
    });
  }

  _setTimer() {
    _animationTimer?.cancel();
    _animationTimer = Timer.periodic(
      const Duration(milliseconds: 40),
      (_) {
        setState(() {
          if (_column < _horizontalAxisProcessingMatrixColumnsCount) {
            if (_row == _horizontalAxisProcessingMatrixRowsCount &&
                _column == _horizontalAxisProcessingMatrixLastRowColumnsCount) {
              _column = 1;
              _row = 1;
            } else {
              _column++;
            }
          } else if (_column == _horizontalAxisProcessingMatrixColumnsCount) {
            if (_row == _horizontalAxisProcessingMatrixRowsCount) {
              if (_verticalAxisProcessingColumnRowsCount > 0) {
                _column = 1 + _horizontalAxisProcessingMatrixColumnsCount;
                _row = 1;
              } else {
                _column = 1;
                _row = 1;
              }
            } else {
              _column = 1;
              _row++;
            }
          } else if (_column ==
              1 + _horizontalAxisProcessingMatrixColumnsCount) {
            if (_row == _verticalAxisProcessingColumnRowsCount) {
              _column = 1;
              _row = 1;
            } else {
              _row++;
            }
          }
        });
      },
    );
  }

  @override
  Widget build(final BuildContext context) {
    if (_loadedImage == null) {
      return const SizedBox(
        width: _squareImageWidth,
      );
    }
    const Size size = Size(_squareImageWidth, _squareImageWidth);
    final Axis axis = _column == 1 + _horizontalAxisProcessingMatrixRowsCount
        ? Axis.vertical
        : Axis.horizontal;
    return RepaintBoundary(
      key: widget.key,
      child: CustomPaint(
        painter: AnimationPainter(
          image: _loadedImage!,
          sourceSize: size,
          scale: 1,
          index: (axis == Axis.vertical ? _row : _column) - 1,
          axis: axis,
          offsetX: axis == Axis.horizontal
              ? 0
              : _horizontalAxisProcessingMatrixRowsCount,
          offsetY: axis == Axis.vertical ? 0 : _row - 1,
          flipX: false,
          flipY: false,
        ),
        size: size,
      ),
    );
  }

  @override
  void dispose() {
    _animationTimer?.cancel();
    super.dispose();
  }
}
