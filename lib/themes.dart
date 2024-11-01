import 'package:flutter/material.dart';

// Primary Color
Color primaryColor = Color(0xFF5CDD8B);

// Primary font
String primaryFontFamily = 'Raleway';

// Material App Themes
ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorSchemeSeed: primaryColor,
  fontFamily: primaryFontFamily,
  textTheme: ralewayTheme,
  useMaterial3: true,
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorSchemeSeed: primaryColor,
  fontFamily: primaryFontFamily,
  textTheme: ralewayTheme,
  useMaterial3: true,
);

// Text Themes
TextTheme ralewayTheme = TextTheme(
  // display
  displayLarge: fontBoldTextStyle,
  displayMedium: fontNormalTextStyle,
  displaySmall: fontLightTextStyle,
  // headline
  headlineLarge: fontBoldTextStyle,
  headlineMedium: fontNormalTextStyle,
  headlineSmall: fontLightTextStyle,
  // title
  titleLarge: fontBoldTextStyle,
  titleMedium: fontNormalTextStyle,
  titleSmall: fontLightTextStyle,
  // label
  labelLarge: fontBoldTextStyle,
  labelMedium: fontNormalTextStyle,
  labelSmall: fontLightTextStyle,
  //body
  bodyLarge: fontBoldTextStyle,
  bodyMedium: fontLightTextStyle,
  bodySmall: fontLightTextStyle,
);

// Text Styles
TextStyle fontBolderTextStyle = TextStyle(fontVariations: fontBolder);
TextStyle fontBoldTextStyle = TextStyle(fontVariations: fontBold);
TextStyle fontNormalTextStyle = TextStyle(fontVariations: fontNormal);
TextStyle fontLightTextStyle = TextStyle(fontVariations: fontLight);

// Font Variation lists
List<FontVariation> fontBolder = [FontVariation('wght', 900)];
List<FontVariation> fontBold = [FontVariation('wght', 600)];
List<FontVariation> fontNormal = [FontVariation('wght', 500)];
List<FontVariation> fontLight = [FontVariation('wght', 300)];
