import '../flavor_config.dart';
import '../app_exception.dart';
import 'logger.dart';

class Version {
  static const int UNKNOWN = 0;
  static const int UPDATE_REQUIRED = 1;
  static const int UPDATE_AVAILABLE = 2;
  static const int ON_LATEST_VERSION = 3;

  int minimalVersion;
  int currentVersion;
  String clientVersion;

  Version({
    this.minimalVersion,
    this.currentVersion,
    this.clientVersion,
  });

  factory Version.fromJson(Map<String, dynamic> json) => Version(
      minimalVersion: json['minimalVersion'],
      currentVersion: json['currentVersion'],
      clientVersion: json['clientVersion']);

  ///will return one of the Version
  ///statuses (ON_LATEST_VERSION,UPDATE_AVAILABLE,UPDATE_REQUIRED or UNKNOWN)
  ///depending on app version and server versions
  int getStatus() {
    if(currentVersion == null){
      Log.error("no currentVersion", error: AppException(errorMessage: "no currentVersion"));
      return UNKNOWN;
    }

    if(minimalVersion == null){
      Log.error("no minimalVersion", error: AppException(errorMessage: "no minimalVersion"));
      return UNKNOWN;
    }

    try {
      int appVersion = int.parse(FlavorConfig.instance.buildNumber);
      if (appVersion >= currentVersion) {
        return ON_LATEST_VERSION;
      } else if (appVersion >= minimalVersion) {
        return UPDATE_AVAILABLE;
      } else {
        return UPDATE_REQUIRED;
      }
    } catch (e) {
      Log.error("error parsing build number", error: e);
    }
    return UNKNOWN;
  }
}
