import 'package:flutter/foundation.dart';

class NavigationProvider extends ChangeNotifier {
  int _selectedIndex = 0;
  bool _isInSettingsPage = false;

  int get selectedIndex => _selectedIndex;
  bool get isInSettingsPage => _isInSettingsPage;

  void setIndex(int index) {
    _selectedIndex = index;
    _isInSettingsPage = false;
    notifyListeners();
  }

  void openSettingsPage() {
    _isInSettingsPage = true;
    notifyListeners();
  }

  void closeSettingsPage() {
    _isInSettingsPage = false;
    notifyListeners();
  }
}
