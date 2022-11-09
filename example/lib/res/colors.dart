import 'package:flutter/material.dart';
import 'package:g_base_package/base/utils/extensions.dart' as extensions;

///Here we will keep references to colors like a style
class AppColors {
  static void updatePrimaryColor(Color color) {
    primaryColor = color;
  }

  ///any color related to accent color must be updated as well
  static void updateAccentColor(Color color) {
    accentColor = color;
    accentColorWithHalfAlpha = color.withOpacity(0.5);
    btnMain = color;
  }

  static final red = Colors.red;
  static final lightBlueAccent = Colors.lightBlueAccent;
  static final seaBuckthorn = extensions.BaseColor.fromHex("F49F27");
  static final tundora = extensions.BaseColor.fromHex("4D4D4D");

  static var primaryColor = Color(0xFF4D4D4D);
  static var accentColor = Color(0xFFF7A100);
  static var accentColorWithHalfAlpha = Color(0x80F7A100);

  static final accentColor2 = Color(0xFF738288);
  static final appBackground = Colors.white;
  static final regularText = Colors.black87;
  static final errorText = Colors.red;

  static final splash = Color(0xFF231f20);
  static final darkText = Color(0xFF141434);
  static final hintText = Color(0xFF7d8699);

  static final white = Color(0xFFffffff);

  static final line = Color(0xFFf0f0f0);
  static final lightText = white;

  static var btnMain = accentColor;
  static final btnSecond = accentColor2;

  static final unSuccess = Colors.grey[400];
  static final ripple = accentColor2;
  static final transparent = Colors.transparent;
  static final black = Colors.black;
}
