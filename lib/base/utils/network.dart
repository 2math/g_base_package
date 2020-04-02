
import 'package:connectivity/connectivity.dart';

class NetUtil {
    Future<ConnectivityResult> checkNetwork() async {
        return (Connectivity().checkConnectivity());
    }

    Future<bool> isMobile() async {
        var connectivityResult = await (Connectivity().checkConnectivity());
        return connectivityResult == ConnectivityResult.mobile;
    }

    Future<bool> isWifi() async {
        var connectivityResult = await (Connectivity().checkConnectivity());
        return connectivityResult == ConnectivityResult.wifi;
    }

    Future<bool> hasNetwork() async {
        var connectivityResult = await (Connectivity().checkConnectivity());
        return connectivityResult != ConnectivityResult.none;
    }
}