import 'package:g_base_package/base/flavor_config.dart';

import '../main.dart';
import 'app_flavors.dart';

void main() {
  DevConfig();
  //todo Galeen (07 Apr 2020) : run your app here
//  ZoefApp().run();
}

class DevConfig extends AppBaseConfig {
  DevConfig()
      : super(
          Flavor.DEV,
          baseUrl: "https://zoef-dev.herokuapp.com/",
          webURL: "https://zoef-web-dev.herokuapp.com/",
        );
}
