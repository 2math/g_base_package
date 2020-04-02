import 'package:g_base_package/base/utils/logger.dart';

import '../app_exception.dart';
import '../reporters/analytics.dart';
import '../reporters/crash_reporter.dart';
import 'package:flutter/foundation.dart';

class InstanceProvider<R, C extends BaseCrashReporter,
    A extends BaseAnalyticsUtil> {
  static InstanceProvider _instance;
  static bool _ignoreInstanceForUnitTests = false;

  static InstanceProvider getInstance() {
    if (_instance == null && !_ignoreInstanceForUnitTests) {
//            throw new AppException(errorMessage: "You must init repository on app start" );
      Log.e("You must init repository on app start");
    }
    return _instance;
  }

  @visibleForTesting
  static setIgnoreInstanceForUnitTests(bool value) {
    _ignoreInstanceForUnitTests = value;
  }

  R _repositoryInstance;
  C _crashReporter;
  A _analyticsUtil;

  InstanceProvider.init(
      this._repositoryInstance, this._crashReporter, this._analyticsUtil) {
    _instance = this;
  }

  R provideRepository() {
    return _repositoryInstance;
  }

  @visibleForTesting
  setTestRepositoryInstance(R value) {
    _repositoryInstance = value;
  }

  C get crashReporter => _crashReporter;

  @visibleForTesting
  setTestCrashReporter(C crashReporter) {
    _crashReporter = crashReporter;
  }

  A get analyticsUtil => _analyticsUtil;

  @visibleForTesting
  setTestAnalyticsUtil(A analyticsUtil) {
    _analyticsUtil = analyticsUtil;
  }
}
