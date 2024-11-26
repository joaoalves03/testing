import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

FlexSchemeColor createFlexSchemeColor(Color color) {
  return FlexSchemeColor(
    primary: color,
    primaryContainer: color,
    primaryLightRef: color,
    secondary: color,
    secondaryContainer: color,
    secondaryLightRef: color,
    tertiary: color,
    tertiaryContainer: color,
    tertiaryLightRef: color,
    appBarColor: color,
  );
}

FlexSubThemesData createFlexSubThemesData() {
  return const FlexSubThemesData(
    inputDecoratorIsFilled: true,
    alignedDropdown: true,
    tooltipRadius: 4,
    tooltipSchemeColor: SchemeColor.inverseSurface,
    tooltipOpacity: 0.9,
    snackBarElevation: 6,
    snackBarBackgroundSchemeColor: SchemeColor.inverseSurface,
    navigationRailUseIndicator: true,
    navigationRailLabelType: NavigationRailLabelType.all,
    navigationBarIndicatorSchemeColor: SchemeColor.primaryContainer,
    scaffoldBackgroundSchemeColor: SchemeColor.surface,
    switchThumbSchemeColor: SchemeColor.surfaceDim,
  );
}

FlexKeyColors createFlexKeyColors() {
  return const FlexKeyColors(
    useSecondary: true,
    useTertiary: true,
    keepPrimary: true,
    keepSecondary: true,
    keepTertiary: true,
    keepPrimaryContainer: true,
  );
}

CupertinoThemeData createCupertinoThemeData() {
  return const CupertinoThemeData(applyThemeToAll: true);
}

ThemeData createFlexTheme(Color color, bool isDark) {
  return isDark
      ? FlexThemeData.dark(
          colors: createFlexSchemeColor(color),
          subThemesData: createFlexSubThemesData(),
          keyColors: createFlexKeyColors(),
          cupertinoOverrideTheme: createCupertinoThemeData(),
        )
      : FlexThemeData.light(
          colors: createFlexSchemeColor(color),
          subThemesData: createFlexSubThemesData(),
          keyColors: createFlexKeyColors(),
          cupertinoOverrideTheme: createCupertinoThemeData(),
        );
}

Map<String, ThemeData> genTheme(Color color) {
  return {
    "light": createFlexTheme(color, false),
    "dark": createFlexTheme(color, true),
  };
}

ThemeData genIPVCTheme(bool isDark) {
  return isDark
      ? createFlexTheme(Color(0xffffffff), true)
      : createFlexTheme(Color(0xff000000), false);
}

var esaTheme = genTheme(Color(0xff00a885));
var esceTheme = genTheme(Color(0xffe51a2c));
var esdlTheme = genTheme(Color(0xff828181));
var eseTheme = genTheme(Color(0xff0054a4));
var essTheme = genTheme(Color(0xffdca7ac));
var estgTheme = genTheme(Color(0xfff3ab1d));
var ipvcTheme = {
  "light": genIPVCTheme(false),
  "dark": genIPVCTheme(true),
};
