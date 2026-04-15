import 'package:flutter/material.dart';

class NavigationProvider extends ChangeNotifier {
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  int _serviceInitialIndex = 0;
  int get serviceInitialIndex => _serviceInitialIndex;

  void setPageIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void navigateToService(int serviceIndex) {
    _serviceInitialIndex = serviceIndex;
    _currentIndex = 2; // Service tab index in AdvertNavigationpage
    notifyListeners();
  }
}
