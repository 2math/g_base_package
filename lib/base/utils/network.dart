import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:connectivity_plus/connectivity_plus.dart' as connectivity_plus;
import 'package:flutter/foundation.dart';

class NetUtil {
  ///support all platforms except Windows and Linux, use checkNetworkPlus()
  ///if you are working on that platforms
  Future<ConnectivityResult> checkNetwork() async {
    return (Connectivity().checkConnectivity());
  }

  ///support all platforms
  Future<connectivity_plus.ConnectivityResult> checkNetworkPlus() async {
    return (connectivity_plus.Connectivity().checkConnectivity());
  }

  Future<bool> isMobile() async {
    var connectivityResult = await (kIsWeb || Platform.isWindows
        ? connectivity_plus.Connectivity().checkConnectivity()
        : Connectivity().checkConnectivity());
    return connectivityResult == ConnectivityResult.mobile;
  }

  Future<bool> isWifi() async {
    var connectivityResult = await (kIsWeb || Platform.isWindows
        ? connectivity_plus.Connectivity().checkConnectivity()
        : Connectivity().checkConnectivity());
    return connectivityResult == ConnectivityResult.wifi;
  }

  Future<bool> hasNetwork() async {
    var connectivityResult = await (kIsWeb || Platform.isWindows
        ? connectivity_plus.Connectivity().checkConnectivity()
        : Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

  ///makes actual request to google.com and checks real internet connection
  ///If you are connected to WiFi but there is no internet will return false up to 30 sec
  Future<bool> checkInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }
}
