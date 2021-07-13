import 'package:flutter/cupertino.dart';

class FilterButtonProvider extends ChangeNotifier {
  bool _isVisible = true;
  bool get value => _isVisible;

  void setFilterValue(bool value) {
    _isVisible = value;
    notifyListeners();
  }
}