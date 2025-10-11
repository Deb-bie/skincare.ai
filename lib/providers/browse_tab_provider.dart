import 'package:flutter/foundation.dart';

class BrowseTabProvider extends ChangeNotifier {
  int _selectedTab = 0;

  int get selectedTab => _selectedTab;

  void setBrowseTab(int index) {
    _selectedTab = index;
    notifyListeners();
  }
}
