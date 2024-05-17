import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;

  Stream<ConnectivityResult> getNetworkStatus();
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;

  NetworkInfoImpl({
    required this.connectivity,
  });

  @override
  Future<bool> get isConnected => checkConnection();

  Future<bool> checkConnection() async {
    final result = await connectivity.checkConnectivity();
    if (result == ConnectivityResult.none) {
      return false;
    } else {
      return true;
    }
  }

  @override
  Stream<ConnectivityResult> getNetworkStatus() {
    return connectivity.onConnectivityChanged;
  }
}
