import 'package:flutter/material.dart';
import 'package:g_base_package/base/utils/logger.dart';
import 'package:package_info/package_info.dart';

enum Flavor { DEV, STAGE, PROD, TEST }

///This is minimum for app flavor
///Create BaseAppFlavor for each App that extend this one and init common data there
///Then create specific flavor classes that should extend from your BaseAppFlavor
class FlavorConfig {
  static FlavorConfig _instance;
  final Flavor flavor;
  final String baseUrl;

  String _appName;
  String _packageName;
  String _version;
  String _buildNumber;

  final String msgLoadingKey;
  final String unauthorizedKey;
  final String forbiddenKey;
  final String notFoundKey;
  final String unsupportedVersionKey;
  final String noNetworkKey;
  final String serverErrorKey;
  final String headerLanguage,
      headerToken,
      headerContentType,
      headerVersion,
      headerOS;
  final String headerValueAndroid, headerValueIOS;

  FlavorConfig(this.flavor,
      {@required this.baseUrl,
      this.msgLoadingKey,
      this.unauthorizedKey,
      this.forbiddenKey,
      this.notFoundKey,
      this.unsupportedVersionKey,
      this.noNetworkKey,
      this.serverErrorKey,
      this.headerLanguage,
      this.headerToken,
      this.headerContentType,
      this.headerVersion,
      this.headerOS,
      this.headerValueAndroid,
      this.headerValueIOS}) {
    _instance = this;

    if (!isTesting()) {
      WidgetsFlutterBinding.ensureInitialized();

      PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
        _appName = packageInfo.appName;
        _packageName = packageInfo.packageName;
        _version = packageInfo.version;
        _buildNumber = packageInfo.buildNumber;
      }).catchError((e) {
        Log.e("getting app info : $e", "flavorConfig",
            e is Error ? e : AssertionError("$e"));
      });
    }

    Log.w("init flavor $this");
  }

  @override
  String toString() {
    return 'FlavorConfig{flavor: $flavor, baseUrl: $baseUrl, _appName: $_appName, _packageName: $_packageName, _version: $_version, _buildNumber: $_buildNumber, msgLoadingKey: $msgLoadingKey, unauthorizedKey: $unauthorizedKey, forbiddenKey: $forbiddenKey, notFoundKey: $notFoundKey, unsupportedVersionKey: $unsupportedVersionKey, noNetworkKey: $noNetworkKey, serverErrorKey: $serverErrorKey, headerLanguage: $headerLanguage, headerToken: $headerToken, headerContentType: $headerContentType, headerVersion: $headerVersion, headerOS: $headerOS, headerValueAndroid: $headerValueAndroid, headerValueIOS: $headerValueIOS}';
  }

  static FlavorConfig get instance {
    return _instance;
  }

  static bool isProduction() => _instance.flavor == Flavor.PROD;

  static bool isDevelopment() => _instance.flavor == Flavor.DEV;

  static bool isStaging() => _instance.flavor == Flavor.STAGE;

  static bool isTesting() => _instance.flavor == Flavor.TEST;

  String get appName => _appName;

  String get packageName => _packageName;

  String get version => _version;

  String get buildNumber => _buildNumber;
}
