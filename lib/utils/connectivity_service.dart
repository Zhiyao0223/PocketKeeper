import 'dart:async';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';

// This class is used to check connectivity status
// Reference: https://pub.dev/documentation/connectivity_plus/latest/
class ConnectivityService {
  final _connectivity = Connectivity();

  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  // This function is used to initialize the connectivity service
  void init() {
    _connectivitySubscription = _connectivity.onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      log('Connectivity changed: $results');
    });
  }

  // This function is used to dispose the connectivity service
  void dispose() {
    _connectivitySubscription.cancel();
  }

  // This function is used to check if the device is connected to the internet
  Future<bool> isConnected() async {
    try {
      final List<ConnectivityResult> result =
          await _connectivity.checkConnectivity();

      return !result.contains(ConnectivityResult.none);
    } on PlatformException catch (e) {
      log('Error: $e');
      return false;
    }
  }
}
