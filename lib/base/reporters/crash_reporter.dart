import '../flavor_config.dart';
//import 'package:firebase_crashlytics/firebase_crashlytics.dart';
//import 'package:instabug_flutter/Instabug.dart';

//todo provider
class BaseCrashReporter {

  log(String log, [String tag]) {
//    Crashlytics.instance.log('${tag == null ? '' : tag} : $log');
//    Instabug.logUserEvent('$tag : $log');
  }

  logError(String log, [String tag, Error error]) {
//    Crashlytics.instance
//        .recordError(error, null, context: '${tag == null ? '' : tag} : $log');
//    Instabug.logUserEvent('$tag : $log \n $error');
  }

  setDevice(){
      setString("app", FlavorConfig.instance.toString());
  }

//  setUser(User user) {
//    setUserEmail(user?.email);
//    setUserIdentifier(user?.id);
//  }

  setUserEmail(String email) {
//    Crashlytics.instance.setUserEmail(email);
//    Instabug.identifyUser(email);
//    Instabug.setUserAttribute(email,"email");
  }

  setUserIdentifier(String id) {
//    Crashlytics.instance.setUserIdentifier(id);
//    Instabug.setUserAttribute(id,"id");
  }

  setUserName(String name) {
//    Crashlytics.instance.setUserName(name);
//    Instabug.setUserAttribute(name,"name");
  }

  setBool(String key, bool value) {
//    Crashlytics.instance.setBool(key, value);
//    Instabug.setUserAttribute(value.toString(),key);
  }

  setString(String key, String value) {
//    Crashlytics.instance.setString(key, value);
//    Instabug.setUserAttribute(value,key);
  }

  setInt(String key, int value) {
//    Crashlytics.instance.setInt(key, value);
//    Instabug.setUserAttribute(value.toString(),key);
  }

  setDouble(String key, double value) {
//    Crashlytics.instance.setDouble(key, value);
//    Instabug.setUserAttribute(value.toString(),key);
  }
}
