import 'package:example/res/res.dart';
import 'package:g_base_package/base/flavor_config.dart';

///Custom app config file for each application. Each app flavor must extend from it
///so all flavors will share same fields. Also set common data here
abstract class AppBaseConfig extends FlavorConfig {
  static AppBaseConfig? _instance;

  final String webURL;

  AppBaseConfig(Flavor flavor, {required baseUrl, required this.webURL})
      : super(flavor,
            baseUrl: baseUrl,
            msgLoadingKey: StrKey.msgLoading,
            noNetworkKey: StrKey.noNetwork,
            serverErrorKey: StrKey.serverError,
            unauthorizedKey: StrKey.unauthorized,
            forbiddenKey: StrKey.forbidden,
            notFoundKey: StrKey.notFound,
            unsupportedVersionKey: StrKey.unsupportedVersion,
            headerToken: "x-auth-token",
            headerLanguage: "Accept-Language",
            headerContentType: "Content-Type",
            headerVersion: "x-version",
            headerOS: "x-os",
            headerValueAndroid: "ANDROID_ASSETTRAX",
            headerValueIOS: "IOS") {
    _instance ??= this;
  }

  static AppBaseConfig? get instance {
    return _instance;
  }
}
