import 'package:flutter/material.dart';

// Primary Color
Color themeColor = Color(0xFF5CDD8B);
Color setupScreenThemeColor = Color(0xFFCCEEFF);

// Font Families
String primaryFontFamily = 'Raleway';
String secondaryFontFamily = 'Quicksand';
String setupPrimaryFontFamily = 'Michroma';

// Material App Themes
ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorSchemeSeed: themeColor,
  fontFamily: primaryFontFamily,
  textTheme: ralewayTheme,
  useMaterial3: true,
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorSchemeSeed: themeColor,
  fontFamily: primaryFontFamily,
  textTheme: ralewayTheme,
  useMaterial3: true,
);

ThemeData setupTheme = ThemeData(
  brightness: Brightness.light,
  colorSchemeSeed: setupScreenThemeColor,
  fontFamily: setupPrimaryFontFamily,
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

// Text Styles for Variable fonts
TextStyle fontBolderTextStyle = TextStyle(fontVariations: fontBolder);
TextStyle fontBoldTextStyle = TextStyle(fontVariations: fontBold);
TextStyle fontNormalTextStyle = TextStyle(fontVariations: fontNormal);
TextStyle fontLightTextStyle = TextStyle(fontVariations: fontLight);

// Variable Font Weights
List<FontVariation> fontBoldest = [FontVariation('wght', 900)];
List<FontVariation> fontBolder = [FontVariation('wght', 700)];
List<FontVariation> fontBold = [FontVariation('wght', 600)];
List<FontVariation> fontNormal = [FontVariation('wght', 500)];
List<FontVariation> fontLight = [FontVariation('wght', 300)];

/*
 *   Onboarding Screen Themes
 */
Color setupScreenPrimaryColor = Colors.black;
Color setupScreenSubtitleColor = Colors.blueGrey;

TextStyle splashScreenHeader = TextStyle(
  fontSize: 25,
  fontVariations: fontBolder,
);
TextStyle splashScreenSubtitle = TextStyle(
  color: setupScreenSubtitleColor,
  fontFamily: secondaryFontFamily,
  fontSize: 13,
  fontVariations: fontNormal,
);
TextStyle setupScreenHeader = TextStyle(
  fontSize: 28,
  fontVariations: fontBold,
);
TextStyle setupScreenSubtitle = TextStyle(
  color: setupScreenSubtitleColor,
  fontFamily: secondaryFontFamily,
  fontSize: 15,
  fontVariations: fontNormal,
);
TextStyle setupButtonText = TextStyle(
  fontFamily: primaryFontFamily,
  fontVariations: fontNormal,
  fontSize: 20,
);
TextStyle setupInputFieldText = TextStyle(
  fontFamily: primaryFontFamily,
);
TextStyle linkTextStyle = TextStyle(
  decoration: TextDecoration.underline,
);

Icon setupNextButtonIcon = Icon(
  Icons.navigate_next,
  size: 40,
);

ButtonStyle setupNextButtonStyle(BuildContext context) {
  return OutlinedButton.styleFrom(
    shape: CircleBorder(),
    padding: EdgeInsets.all(8),
    side: BorderSide(
      color: Theme.of(context).colorScheme.primary,
    ),
  );
}

ButtonStyle loginButtonStyle(BuildContext context) {
  return OutlinedButton.styleFrom(
    enableFeedback: true,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
    padding: EdgeInsets.symmetric(
      horizontal: 40,
      vertical: 8,
    ),
    side: BorderSide(
      width: 2,
      color: Theme.of(context).colorScheme.primary,
    ),
  );
}
