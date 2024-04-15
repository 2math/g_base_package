import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';

class NetUtil {
  Future<ConnectivityResult> checkNetwork() async {
    return (await Connectivity().checkConnectivity())[0];
  }

  Future<List<ConnectivityResult>> checkNetworkConnectivity() async {
    return Connectivity().checkConnectivity();
  }

  ///support all platforms
  // Future<connectivity_plus.ConnectivityResult> checkNetworkPlus() async {
  //   return (connectivity_plus.Connectivity().checkConnectivity());
  // }

  Future<bool> isMobile() async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    for (final conn in connectivityResult) {
      if (conn == ConnectivityResult.mobile) return true;
    }

    return false;
  }

  Future<bool> isWifi() async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    for (final conn in connectivityResult) {
      if (conn == ConnectivityResult.wifi) return true;
    }

    return false;
  }

  Future<bool> hasNetwork() async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    for (final conn in connectivityResult) {
      if (conn != ConnectivityResult.none) return true;
    }

    return false;
  }

  ///Makes actual request to google.com and checks real internet connection.
  ///If you are connected to WiFi but there is no internet will return false up to 30 sec.
  ///Not working on web!
  Future<bool> checkInternet() async {
    try {
      final result = await InternetAddress.lookup('bing.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }
}
