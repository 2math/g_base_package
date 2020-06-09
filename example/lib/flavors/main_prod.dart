import 'package:g_base_package/base/flavor_config.dart';

import 'app_flavors.dart';

void main() {
  ProdConfig();
  //todo Galeen (07 Apr 2020) : run your app here
//  ZoefApp().run();
}

class ProdConfig extends AppBaseConfig {
  ProdConfig()
      : super(
          Flavor.PROD,
          baseUrl: "https://zoef-prod.herokuapp.com/",
          webURL: "https://zoef-web-prod.herokuapp.com/",
        );
}
