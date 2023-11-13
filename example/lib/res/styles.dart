import 'package:flutter/material.dart';
import 'colors.dart';
import 'dimensions.dart';


class Style {
  static void refreshTheme() {
    appTheme = ThemeData(
      primaryColor: AppColors.primaryColor,
      colorScheme: ColorScheme.light(
        primary: AppColors.primaryColor,
        secondary: AppColors.accentColor,
        background: AppColors.appBackground,
      ),
      /* fontFamily: "Gilroy"*/
    );
  }

  static var appTheme = ThemeData(
    primaryColor: AppColors.primaryColor,
    colorScheme: ColorScheme.light(
      primary: AppColors.primaryColor,
      secondary: AppColors.accentColor,
      background: AppColors.appBackground,
    ),
    /* fontFamily: "Gilroy"*/
  );

  static final regularText =
      TextStyle(color: AppColors.regularText, fontSize: Dimen.normalText, fontWeight: FontWeight.normal);

  static final boldText = regularText.copyWith(fontWeight: FontWeight.bold);

  static final mediumText = regularText.copyWith(fontWeight: FontWeight.w600 /*fontFamily: "Gil
  roy-Medium"*/
      );

  static final lightText = regularText.copyWith(fontWeight: FontWeight.w100 /*fontFamily: "Gilroy
  -Light"*/
      );

  static final italicText = regularText.copyWith(fontStyle: FontStyle.italic);

  static final liteText = TextStyle(color: AppColors.hintText, fontSize: Dimen.normalText, fontWeight: FontWeight.w100);

  static final titleText =
      TextStyle(color: AppColors.darkText, fontSize: Dimen.titleTextSize, fontWeight: FontWeight.bold);

  static final titleScreen = titleText.copyWith(
    color: AppColors.lightText,
  );

  static final listCheckboxText = regularText.copyWith(
    fontSize: Dimen.xBigText,
  );

  static final tabText = TextStyle(color: AppColors.lightText, fontSize: Dimen.xBigText, fontWeight: FontWeight.bold);

  static final etUnderLine =
      new UnderlineInputBorder(borderSide: new BorderSide(color: AppColors.accentColor, width: 1));

  static final etUnderErrorLine =
      new UnderlineInputBorder(borderSide: new BorderSide(color: AppColors.errorText, width: 1));

  static final etText =
      TextStyle(color: AppColors.regularText, fontSize: Dimen.etTextSize, fontWeight: FontWeight.normal);

  static final hintDropDown = hintText.copyWith(
    fontSize: Dimen.etTextSize * 0.75,
  );

  static final hintText = TextStyle(color: AppColors.hintText, fontSize: Dimen.etTextSize, fontWeight: FontWeight.w300);

  static final errorText =
      TextStyle(color: AppColors.errorText, fontSize: Dimen.etTextSize, fontWeight: FontWeight.w300);

  static final statusText =
      TextStyle(color: AppColors.accentColor, fontSize: Dimen.normalText, fontWeight: FontWeight.normal);

  static final attributeButton = TextStyle(color: AppColors.white, fontSize: Dimen.buttonsText);

  static final etBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
  );

  static final safeAreaBottom = Container(
    color: AppColors.primaryColor,
    height: Dimen.safeAreaBottom,
  );

  static final normalSpaceH = SizedBox(
    height: Dimen.paddingNormal,
  );

  static final normalSpaceW = SizedBox(
    width: Dimen.paddingNormal,
  );
  static final smallSpaceH = SizedBox(
    height: Dimen.paddingSmall,
  );
  static final smallSpaceW = SizedBox(
    width: Dimen.paddingSmall,
  );
  static final bigSpaceH = SizedBox(
    height: Dimen.paddingBig,
  );
  static final bigSpaceW = SizedBox(
    width: Dimen.paddingBig,
  );
  static final xbigSpaceH = SizedBox(
    height: Dimen.paddingXBig,
  );
  static final xbigSpaceW = SizedBox(
    width: Dimen.paddingXBig,
  );
  static final xxbigSpaceH = SizedBox(
    height: Dimen.paddingXXBig,
  );

  static final xxbigSpaceW = SizedBox(
    width: Dimen.paddingXXBig,
  );

  static final microSpaceH = SizedBox(
    height: Dimen.paddingMicro,
  );

  static final microSpaceW = SizedBox(
    width: Dimen.paddingMicro,
  );

  static final lineW = Container(
    height: 1,
    color: AppColors.line,
  );

  static final lineH = Container(
    width: 1,
    color: AppColors.line,
  );

  ///when you need to return a widget but has to be Gone
  static final emptySpace = SizedBox(
    height: 0,
    width: 0,
  );

  static final centerLoading = Center(
    child: CircularProgressIndicator(),
  );

  static final dropdownButtonStyle = TextStyle(color: AppColors.primaryColor);
  static final dropdownButtonUnderline = Container(height: 2, color: AppColors.accentColor);
}
