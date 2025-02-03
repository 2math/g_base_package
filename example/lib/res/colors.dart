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
    accentColorWithHalfAlpha = color.withAlpha((255.0 * 0.5).round());
    btnMain = color;
  }

  static const red = Colors.red;
  static const lightBlueAccent = Colors.lightBlueAccent;
  static final seaBuckthorn = extensions.BaseColor.fromHex("F49F27");
  static final tundora = extensions.BaseColor.fromHex("4D4D4D");

  static var primaryColor = const Color(0xFF4D4D4D);
  static var accentColor = const Color(0xFFF7A100);
  static var accentColorWithHalfAlpha = const Color(0x80F7A100);

  static const accentColor2 = Color(0xFF738288);
  static const appBackground = Colors.white;
  static const regularText = Colors.black87;
  static const errorText = Colors.red;

  static const splash = Color(0xFF231f20);
  static const darkText = Color(0xFF141434);
  static const hintText = Color(0xFF7d8699);

  static const white = Color(0xFFffffff);

  static const line = Color(0xFFf0f0f0);
  static const lightText = white;

  static var btnMain = accentColor;
  static const btnSecond = accentColor2;

  static final unSuccess = Colors.grey[400];
  static const ripple = accentColor2;
  static const transparent = Colors.transparent;
  static const black = Colors.black;
}
