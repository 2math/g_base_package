import 'package:g_base_package/base/utils/system.dart';

//safeBlockHorizontal: 4.32 pixel 3a XL
class Dimen {
  static final screenHorizontalFull = SizeConfig.safeBlockHorizontal! * 100;
  static final screenHorizontalHalf = SizeConfig.safeBlockHorizontal! * 50;
  static final screenHorizontalQuarter = SizeConfig.safeBlockHorizontal! * 25;
  static final screenHorizontalSafeArea = SizeConfig.safeBlockHorizontal! * 5;

  static final screenVerticalQuarter = SizeConfig.safeBlockVertical! * 25;

  static final safeAreaBottom = SizeConfig.safeAreaBottom;

  static final paddingNormal = SizeConfig.safeBlockHorizontal! * 4.65;
  static final paddingSmall = SizeConfig.safeBlockHorizontal! * 2.35;
  static final paddingBig = SizeConfig.safeBlockHorizontal! * 6.95;
  static final paddingXBig = SizeConfig.safeBlockHorizontal! * 9.25;
  static final paddingMicro = SizeConfig.safeBlockHorizontal! * 2.0;
  static final paddingXXBig = SizeConfig.safeBlockHorizontal! * 20;

  static const cornersBig = 20.0;

  static final smallTextSize = SizeConfig.safeBlockHorizontal! * 2.0;
  static final normalText = smallTextSize * 1.7;
  static final bigText = normalText * 1.1;
  static final xBigText = normalText * 1.5;
  static final buttonsText = normalText * 1.3;

  static final welcomeTextSize = SizeConfig.safeBlockHorizontal! * 10.0;
  static final etTextSize = SizeConfig.safeBlockHorizontal! * 4.5;
  static final titleTextSize = SizeConfig.safeBlockHorizontal! * 5.8;
  static final skipTextSize = smallTextSize * 2.2;

  static final btnHeight = SizeConfig.safeBlockHorizontal! * 12.0;
  static final btnWidthCal = SizeConfig.safeBlockHorizontal! * 30.0;
  static final btnWidthWelcome = SizeConfig.safeBlockHorizontal! * 80.0;
  static final btnWidthGradient = SizeConfig.safeBlockHorizontal! * 69.0;
  static final btnGradientHeight = SizeConfig.safeBlockHorizontal! * 17.0;
  static final halfScreen = SizeConfig.safeBlockHorizontal! * 50.0;

  static final circleBtnSize = SizeConfig.safeBlockHorizontal! * 18.5;
  static final circleBtnRadius = screenHorizontalQuarter;

  static const lineWidth = 1.0;
  static final logoWidth = SizeConfig.safeBlockHorizontal! * 60.0;
  static final logoHeight = SizeConfig.safeBlockHorizontal! * 23.75;

  static final topImageWidth = SizeConfig.safeBlockHorizontal! * 100.0;
  static final topImageHeight = SizeConfig.safeBlockVertical! * 35.0;
  static final searchIconWidth = SizeConfig.safeBlockHorizontal! * 11.57;
  static final searchIconHeight = SizeConfig.safeBlockHorizontal! * 10.42;
  static final searchPaddingLeft = SizeConfig.safeBlockHorizontal! * 10.65;

  static final cameraButtonIconSize = 32.0;
  static final dropdownButtonIconSize = 24.0;
  static final dropdownButtonElevation = 16;
  static final uploadImageHeight = 100.0;

  static final tuto4ImageSize = SizeConfig.safeBlockHorizontal! * 100.0; //full safe width
  static final homeSuccessImageSize = SizeConfig.safeBlockVertical! * 33.0 > SizeConfig.safeBlockHorizontal! * 70.0
      ? SizeConfig.safeBlockHorizontal! * 70.0
      : SizeConfig.safeBlockVertical! * 33.0; // 30% of screen height or 70% of width
}
