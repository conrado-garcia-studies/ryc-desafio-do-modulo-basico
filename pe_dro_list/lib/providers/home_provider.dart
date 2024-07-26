import 'package:flutter/material.dart';

class HomeProvider with ChangeNotifier {
  int _bottomNavigationBarIndex = 0;
  Widget? _subcontent;
  bool isProcessing = false;

  int get bottomNavigationBarIndex => _bottomNavigationBarIndex;

  set bottomNavigationBarIndex(final int bottomNavigationBarIndex) {
    _subcontent = null;
    _bottomNavigationBarIndex = bottomNavigationBarIndex;
    notifyListeners();
  }

  Widget? get subcontent => _subcontent;

  set subcontent(final Widget? subcontent) {
    _subcontent = subcontent;
    notifyListeners();
  }
}
