import 'package:flutter/material.dart';

class ColorConst {
  static const kBlueBorder = Color(0xFF333D4C);
  static const kRed = Color(0xFFD12929);
  static const kGreen = Color(0xFF479951);
  static const kGreenGlassy = Color(0x224DE515);
  static const kBlueDivGlassy = Color(0x20334469);
  static const kRedGlassy = Color(0x22CE4C06);
  static const kGreenGlassyBorder = Color(0xFF395B2C);
  static const kRedGlassyBorder = Color(0xFF5C2202);
  static const kRedAlert = Color(0xFFEE454A);
  static const kBlue = Color(0xFF007AFF);
  static const kGrey = Color(0x22898989);
  // static const kGold = Color(0xFFEDB31E);

  // dark-theme
  // static const kPrimaryColor = Color(0xFF1F5DE0); //Blue
  static const kPrimaryColor = Color(0xFF2FA926); //Green
  static const kSecondaryColor = Color(0xFF9AD7D4);
  static const kWhiteColor = Color(0xFFF3F1F3);
  static const kWhiteDragColor = Color(0xFFCFD2D8);
  static const kBlackColor = Color(0xFF0B0B0B);
  static const kLightBlue = Color(0xFFD3E1FF);
  static const kDividerGreen = Color(0xFF0FBC3D);
  static const kDividerGrey = Color(0xFF000B2F);
  static const kFontGreen = Color(0xFFE1F9DF);
  static const kCategoryGreen = Color(0xFF205E1D);
  static const kPayoutFirst = Color(0xFFC5E600);

  static const kGray100 = Color(0xFFCCCCCC);
  static const kGray200 = Color(0xFF727171);
  static const kGray300 = Color(0xFF6F6F6F);
  static const kGray400 = Color(0xFF3A3A3A);
  static const kGray500 = Color(0xFF292929);
  static const kGray600 = Color(0xFF171717);
  static const kGray700 = Color(0xFF1F2021);
  static const kDarkGreyColor = Color(0xFF7C7B7C);

  static const kLightBlack = Color(0x20000311);
  static const kDarkGray = Color(0x2266676B);
  static const kLightGray = Color(0x80121315);
  static const kMDarkGray = Color(0xFF323232);

  static const kLightBorderColor = Color(0xFF313131);
  static const kGrayColor = Color(0xFF1A1A1A);

  static const kRedColor = Color(0xFFEF5151);
  static const kMetaMaskColor = Color(0xFFF5851D);

  // Gold, Platinum, Silver
  static const kLightGrayColor = Color(0xFFBBBBBB);
  static const String kWhiteColorString = '#ffffff';
  static const String kPrimaryColorString = '#2FA926';
}

/// Color convertor
class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

extension ColorExtension on String {
  Color? toColor() {
    var hexColor = replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }
    return null;
  }
}

extension MaterialCode on Color {
  MaterialColor toMaterialColor() {
    final List<double> strengths = <double>[.05];
    final Map<int, Color> swatch = {};
    for (var i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (final strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        (r + ((ds < 0 ? r : (255 - r)) * ds).round()).toInt(),
        (g + ((ds < 0 ? g : (255 - g)) * ds).round()).toInt(),
        (b + ((ds < 0 ? b : (255 - b)) * ds).round()).toInt(),
        1,
      );
    }
    return MaterialColor(hashCode, swatch);
  }
}
