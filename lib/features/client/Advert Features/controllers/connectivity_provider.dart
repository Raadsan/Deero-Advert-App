import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectivityProvider extends ChangeNotifier {
  bool _isOnline = true;
  bool get isOnline => _isOnline;

  late StreamSubscription<List<ConnectivityResult>> _subscription;

  ConnectivityProvider() {
    _checkInitialConnectivity();
    _subscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      _updateConnectionStatus(results);
    });
  }

  Future<void> _checkInitialConnectivity() async {
    final List<ConnectivityResult> results = await Connectivity().checkConnectivity();
    _updateConnectionStatus(results);
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
      // Haddii liisku madhan yahay ama uu ka kooban yahay kaliya 'none', markaas waa Offline
    _isOnline = results.isNotEmpty && !results.contains(ConnectivityResult.none);
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
