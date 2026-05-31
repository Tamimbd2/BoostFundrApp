import 'package:boost_fundr/export.dart';
import 'package:flutter/cupertino.dart';

class AppTheme {
  static Color get primary => ColorConst.kPrimaryColor;
  static ThemeData darkTheme = ThemeData(
    unselectedWidgetColor: ColorConst.kDarkGreyColor,
    fontFamily: 'Montserrat',
    brightness: Brightness.dark,
    scaffoldBackgroundColor: ColorConst.kBlackColor,
    highlightColor: Colors.transparent,
    splashColor: Colors.transparent,
    splashFactory: NoSplash.splashFactory,
    primarySwatch: ColorConst.kPrimaryColor.toMaterialColor(),
    primaryColor: ColorConst.kPrimaryColor,
    buttonTheme: _darkButtonTheme,
    colorScheme: _darkColorScheme,
    textTheme: _darkTextTheme,
    tabBarTheme: _darkTabBarTheme,
    pageTransitionsTheme: _pageTransitionsTheme,
    inputDecorationTheme: _darkInputDecorationTheme,
    radioTheme: _darkRadioTheme,
    checkboxTheme: _darkCheckBoxTheme,
    dropdownMenuTheme: _darkDropDownTheme,
    dividerTheme: _darkDividerTheme,
    bottomNavigationBarTheme: _darkNavBarTheme,
    bottomSheetTheme: _darkBottomSheetTheme,
  );

  static const BottomSheetThemeData _darkBottomSheetTheme = BottomSheetThemeData(
    backgroundColor: ColorConst.kGray600,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
    modalBackgroundColor: ColorConst.kGray600,
  );

  static const BottomNavigationBarThemeData _darkNavBarTheme = BottomNavigationBarThemeData(
    backgroundColor: ColorConst.kBlackColor,
    type: BottomNavigationBarType.fixed,
    selectedItemColor: ColorConst.kPrimaryColor,
    unselectedItemColor: ColorConst.kGray100,
  );
  static const DividerThemeData _darkDividerTheme = DividerThemeData(color: ColorConst.kGray600, space: s10);

  static const ColorScheme _darkColorScheme = ColorScheme.light(
    primary: ColorConst.kPrimaryColor,
    onPrimary: ColorConst.kWhiteColor,
    surface: ColorConst.kBlackColor,
    onSurface: ColorConst.kWhiteColor,
    secondary: ColorConst.kSecondaryColor,
    onSecondary: ColorConst.kWhiteColor,
    brightness: Brightness.dark,
    tertiary: ColorConst.kPrimaryColor,
    outline: ColorConst.kWhiteColor,
  );

  static final InputDecorationTheme _darkInputDecorationTheme = InputDecorationTheme(
    filled: true,
    fillColor: Colors.white.withValues(alpha: 0.05),
    border: OutlineInputBorder(
      borderRadius: const BorderRadius.all(radius12),
      borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: const BorderRadius.all(radius12),
      borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: const BorderRadius.all(radius12),
      borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: const BorderRadius.all(radius12),
      borderSide: const BorderSide(color: ColorConst.kPrimaryColor, width: 1),
    ),
    errorBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(radius12),
      borderSide: BorderSide(color: ColorConst.kRedAlert),
    ),
    focusedErrorBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(radius12),
      borderSide: BorderSide(color: ColorConst.kRedAlert),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
  );

  static const ButtonThemeData _darkButtonTheme = ButtonThemeData(
    buttonColor: ColorConst.kPrimaryColor,
    disabledColor: ColorConst.kLightGrayColor,
  );

  static final DropdownMenuThemeData _darkDropDownTheme = DropdownMenuThemeData(
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.05),
      iconColor: ColorConst.kWhiteColor,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: ColorConst.kPrimaryColor),
      ),
    ),
  );

  static const TextTheme _darkTextTheme = TextTheme(
    labelSmall: TextStyle(color: ColorConst.kWhiteColor, fontSize: 10),
    labelLarge: TextStyle(color: ColorConst.kWhiteColor, fontSize: 12, fontWeight: FontWeight.w600),
    bodySmall: TextStyle(color: ColorConst.kWhiteColor, fontSize: 12),
    bodyMedium: TextStyle(color: ColorConst.kWhiteColor, fontSize: 14),
    bodyLarge: TextStyle(color: ColorConst.kWhiteColor, fontSize: 16),
    titleSmall: TextStyle(color: ColorConst.kWhiteColor, fontSize: 14, fontWeight: FontWeight.w700),
    titleMedium: TextStyle(color: ColorConst.kWhiteColor, fontSize: 16, fontWeight: FontWeight.w700),
    titleLarge: TextStyle(color: ColorConst.kWhiteColor, fontSize: 20, fontWeight: FontWeight.w700),
    headlineMedium: TextStyle(color: ColorConst.kWhiteColor, fontSize: 18, fontWeight: FontWeight.w500),
    headlineLarge: TextStyle(color: ColorConst.kWhiteColor, fontSize: 24, fontWeight: FontWeight.w700),
    displayLarge: TextStyle(color: ColorConst.kWhiteColor, fontSize: 26, fontWeight: FontWeight.w700),
  );

  static const TabBarThemeData _darkTabBarTheme = TabBarThemeData(
    splashFactory: NoSplash.splashFactory,
    unselectedLabelColor: ColorConst.kGray400,
    indicatorColor: ColorConst.kGray400,
    dividerColor: ColorConst.kGray400,
    dividerHeight: 3,
    indicatorSize: TabBarIndicatorSize.tab,
    labelColor: ColorConst.kPrimaryColor,
    textScaler: TextScaler.noScaling,
    indicator: UnderlineTabIndicator(
      borderSide: BorderSide(width: 3, color: ColorConst.kPrimaryColor),
    ),
  );

  static final RadioThemeData _darkRadioTheme = RadioThemeData(
    fillColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
      if (states.contains(WidgetState.selected)) {
        return ColorConst.kPrimaryColor;
      } else {
        return ColorConst.kWhiteColor;
      }
    }),
  );

  static final _darkCheckBoxTheme = CheckboxThemeData(
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    fillColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
      if (states.contains(WidgetState.selected)) {
        return ColorConst.kPrimaryColor;
      } else {
        return Colors.transparent;
      }
    }),
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
    checkColor: WidgetStateProperty.all(ColorConst.kWhiteColor),
    visualDensity:
        const VisualDensity(vertical: VisualDensity.minimumDensity, horizontal: VisualDensity.minimumDensity),
  );

  static const PageTransitionsTheme _pageTransitionsTheme = PageTransitionsTheme(
    builders: {
      TargetPlatform.android: ZoomPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    },
  );
}
