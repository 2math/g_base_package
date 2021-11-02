//import '../utils/utils.dart';
//import 'package:firebase_analytics/firebase_analytics.dart';
//import 'package:firebase_analytics/observer.dart';

class BaseAnalyticsUtil {
//  static const String _TAG = 'Analytics';
//  static FirebaseAnalytics _analytics;

//  static FirebaseAnalyticsObserver observer;
//  static bool _canLog;

  ///This one must be called before all
//  static init(FirebaseAnalytics analytics) {
//    _analytics = analytics;
//    observer = FirebaseAnalyticsObserver(analytics: _analytics);
//  }

    ///helper method to check if we are in debug mode and skip init and log
//    static bool _canNotLog({bool withInitCheck = true}) {
//        if (_analytics == null) {
//        if (_logNotEnabled == null) {
//            Log.e("Must init Analytics first", null,
//                    StateError('Analytics not initialized'));
//        }
//            return true;
//        }
//
//        if (_logNotEnabled != null) return _logNotEnabled;
//
//        assert(() {
//            //this is code executed in debug mode
//            _logNotEnabled = true;
//        }());
//
//        if (_logNotEnabled != null) {
//            return _logNotEnabled;
//        }else{
//            return _logNotEnabled = false;
//        }
//    return true;
//    }

  Future<void> logEvent(String name, Map<String, dynamic> params) async {
//    if (_canNotLog()) return;
//    await _analytics.logEvent(
//      name: name,
//      parameters: params,
//    );
//
//    Log.d('logEvent succeeded - $name\n$params', _TAG);
  }

//  Future<void> setUser(User user) async {
//    if (_canNotLog()) return;
//    await _analytics.setUserId(user?.id);
//    //todo set props?
//    Log.d('logSetUser succeeded', _TAG);
//  }

  Future<void> setUserId(String? id) async {
//    if (_canNotLog()) return;
//    await _analytics.setUserId(id);
//    Log.d('logSetUserId succeeded $id', _TAG);
  }

  Future<void> setUserProperty(String name, String? value) async {
//    if (_canNotLog()) return;
//    await _analytics.setUserProperty(name: name, value: value);
//    Log.d('logSetUserProperty succeeded $name : $value', _TAG);
  }

  Future<void> logAppOpen() async {
//    if (_canNotLog()) return;
//    await _analytics.logAppOpen();
//    Log.d('logAppOpen succeeded', _TAG);
  }

  Future<void> logCurrentScreen(String screenName) async {
//    if (_canNotLog()) return;
//    await _analytics.setCurrentScreen(
//      screenName: screenName,
//    );
//    Log.d('logCurrentScreen succeeded $screenName', _TAG);
  }

  Future<void> logLogin() async {
//    if (_canNotLog()) return;
//    await _analytics.logLogin();
//    Log.d('logLogin succeeded', _TAG);
  }

  Future<void> logSignUp() async {
//    if (_canNotLog()) return;
//    await _analytics.logSignUp(signUpMethod: "Email");
//    Log.d('logSignUp succeeded', _TAG);
  }

  Future<void> logTutorialBegin() async {
//    if (_canNotLog()) return;
//    await _analytics.logTutorialBegin();
//    Log.d('logTutorialBegin succeeded', _TAG);
  }

  Future<void> logTutorialComplete() async {
//    if (_canNotLog()) return;
//    await _analytics.logTutorialComplete();
//    Log.d('logTutorialComplete succeeded', _TAG);
  }
}
