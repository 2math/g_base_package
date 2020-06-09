import 'package:g_base_package/base/flavor_config.dart';

import 'app_flavors.dart';

void main() {
  StageConfig();
    //todo Galeen (07 Apr 2020) : run your app here
//  ZoefApp().run();
}

class StageConfig extends AppBaseConfig {
  StageConfig()
      : super(
          Flavor.STAGE,
          baseUrl: "https://zoef-staging.herokuapp.com/",
          webURL: "https://zoef-web-staging.herokuapp.com/",
        );
}
