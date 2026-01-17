import 'package:flutter/foundation.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class NavigationProvider extends ChangeNotifier {
  final PersistentTabController _controller = PersistentTabController(initialIndex: 0);

  bool _isInSettingsPage = false;
  bool get isInSettingsPage => _isInSettingsPage;

  void setIndex(int index) {
    _controller.jumpToTab(index);
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
