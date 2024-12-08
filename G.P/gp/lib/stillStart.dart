import 'package:flutter/material.dart';

class SwipeState extends ChangeNotifier {
  double _size = 0.1;

  double get size => _size;

  set size(double value) {
    _size = value;
    notifyListeners();
  }

  void updateSize(double newSize) {
    size = newSize;
  }
}
