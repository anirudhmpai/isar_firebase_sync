import 'dart:async';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:isar_firebase_sync/core/base_controller.dart';

ValueNotifier<bool> isDeviceConnected = ValueNotifier(false);

class ConnectivityProvider extends BaseController {
  Stream<ConnectivityResult> connectivityStream =
      Connectivity().onConnectivityChanged;
  late StreamSubscription<ConnectivityResult> subscription;

  ConnectivityProvider() {
    subscription = Connectivity().onConnectivityChanged.listen((event) async {
      if (event != ConnectivityResult.none) {
        isDeviceConnected.value =
            await InternetConnectionChecker().hasConnection;
        log("Internet connectivity status : ${isDeviceConnected.value}");
      } else {
        isDeviceConnected.value = false;
        log("Internet connectivity status : ${isDeviceConnected.value}");
      }
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }
}
