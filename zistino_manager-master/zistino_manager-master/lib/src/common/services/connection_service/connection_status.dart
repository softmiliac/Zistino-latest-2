import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

enum ConnectionStatus{
  none ,
  connect,
  disconnect
}

class ConnectionStatusController extends GetxController {

  Rx<ConnectionStatus> connectionStatus = ConnectionStatus.none.obs; /// 0 -> No connection /// 1 -> Connected

  final Connectivity _connectivity = Connectivity();

  late StreamSubscription<ConnectivityResult> _subscription;

  @override
  void onInit() {
    initConnectivity();
    _subscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    super.onInit();
  }

  Future<void> initConnectivity() async {
    ConnectivityResult? result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    }
    return _updateConnectionStatus(result);
  }

  _updateConnectionStatus(ConnectivityResult? result) {
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
        connectionStatus.value = ConnectionStatus.connect;
        break;
      case ConnectivityResult.none:
        connectionStatus.value = ConnectionStatus.disconnect;
        break;
      default:
        connectionStatus.value = ConnectionStatus.none;
        break;
    }
  }

  @override
  void onClose() {
    _subscription.cancel();
    super.onClose();
  }
}
