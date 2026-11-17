import 'package:flutter/foundation.dart';

/// Holds the selected tab for the app's bottom navigation bar.
class NavigationProvider extends ChangeNotifier {
  static const int tabCount = 4;

  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void selectTab(int index) {
    if (index < 0 || index >= tabCount) {
      throw RangeError.range(index, 0, tabCount - 1, 'index');
    }
    if (index == _currentIndex) return;

    _currentIndex = index;
    notifyListeners();
  }
}
