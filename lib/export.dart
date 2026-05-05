export 'package:flutter/material.dart';
export 'package:flutter/services.dart';
export 'package:flutter_svg/flutter_svg.dart';
export 'package:get/get.dart' hide Response;
export 'package:boost_fundr/app/widgets/gradient_background.dart';
export 'package:boost_fundr/app/widgets/splash_background.dart';
export 'package:boost_fundr/app/widgets/custom_app_bar.dart';
export 'package:boost_fundr/app/widgets/primary_button.dart';
export 'package:boost_fundr/app/widgets/glass_card.dart';
export 'package:boost_fundr/app/widgets/custom_input.dart';
export 'package:boost_fundr/app/widgets/status_badge.dart';
export 'package:boost_fundr/app/widgets/social_button.dart';
export 'package:boost_fundr/app/theme/color_constants.dart';
export 'package:boost_fundr/app/theme/app_theme.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logger/logger.dart' as log;

const Radius radius8 = Radius.circular(8);
const Radius radius10 = Radius.circular(10);
const Radius radius12 = Radius.circular(12);
const Radius radius20 = Radius.circular(20);

// --- Image Constants ---
class ImageConst {
  static const String icAppLogo2 = 'assets/logo/logo.png';
  static const String icUploadPlus = 'assets/logo/icon/google.svg';
  static const String icPotCircleFill = 'assets/logo/icon/facebook.svg';
  static const String icMetamask = 'assets/logo/icon/google.svg'; // Placeholder
  static const String icCheck = 'assets/logo/icon/google.svg'; // Placeholder
  static const String icLoader = 'assets/logo/icons/ic_loader.gif';
}

// --- Label Constants ---
class LabelConst {
  static const String connectedToMetamask = 'Connected to MetaMask';
  static const String connectingToMetamask = 'Connecting...';
  static const String connectionFailed = 'Connection Failed';
  static const String connectToMetamask = 'Connect MetaMask';
  static const String addressNotFound = 'Address not found';
  static const String openPdf = 'Open PDF';
  static const String connectToMetamaskSuccess = 'Successfully connected!';
}

// --- Helper Extensions & Functions ---
// Color extension removed as withValues is now native in Flutter 3.27+

extension TextStyleExtension on TextStyle {
  TextStyle get w400 => copyWith(fontWeight: FontWeight.w400);
  TextStyle get w500 => copyWith(fontWeight: FontWeight.w500);
  TextStyle get w600 => copyWith(fontWeight: FontWeight.w600);
  TextStyle get w700 => copyWith(fontWeight: FontWeight.w700);
  TextStyle get bold => copyWith(fontWeight: FontWeight.bold);
  TextStyle withColor(Color color) => copyWith(color: color);
}

extension ContextExtension on BuildContext {
  TextStyle get bodyLarge => Theme.of(this).textTheme.bodyLarge!;
  TextStyle get bodyMedium => Theme.of(this).textTheme.bodyMedium!;
  TextStyle get bodySmall => Theme.of(this).textTheme.bodySmall!;
  TextStyle get labelSmall => Theme.of(this).textTheme.labelSmall!;
  TextStyle get displayLarge => Theme.of(this).textTheme.displayLarge!;
  TextStyle get headlineMedium => Theme.of(this).textTheme.headlineMedium!;
}

EdgeInsets padXY(double x, double y) => EdgeInsets.symmetric(horizontal: x, vertical: y);
EdgeInsets padX(double x) => EdgeInsets.symmetric(horizontal: x);
const EdgeInsets py8 = EdgeInsets.symmetric(vertical: 8);
const EdgeInsets p12 = EdgeInsets.all(12.0);
const EdgeInsets p24 = EdgeInsets.all(24.0);
const EdgeInsets p6 = EdgeInsets.all(6.0);
const EdgeInsets p0 = EdgeInsets.zero;

const SizedBox gap4 = SizedBox(height: 4, width: 4);
const SizedBox gap8 = SizedBox(height: 8, width: 8);
const SizedBox gap10 = SizedBox(height: 10, width: 10);
const SizedBox gap12 = SizedBox(height: 12, width: 12);
const SizedBox gap16 = SizedBox(height: 16, width: 16);
const SizedBox gap24 = SizedBox(height: 24, width: 24);

const double s2 = 2.0;
const double s8 = 8.0;
const double s10 = 10.0;
const double s12 = 12.0;
const double s24 = 24.0;
const double s26 = 26.0;
const double s32 = 32.0;
const double s80 = 80.0;

const double bannerRatio = 16 / 9;

BorderRadius borderRadius(double radius) => BorderRadius.circular(radius);
const BorderRadius borderRadius8 = BorderRadius.all(Radius.circular(8));

class Logger {
  static final _logger = log.Logger();
  static void printer({required String title, dynamic message}) {
    _logger.i('$title: $message');
  }
}

class Global {
  static Future<void> openUrl(String url) async {
    // Placeholder for url_launcher logic
  }
}

// --- Custom Widgets ---
class CustomSvgImage extends StatelessWidget {
  final String logo;
  final bool isFlip;
  const CustomSvgImage({super.key, required this.logo, this.isFlip = false});

  @override
  Widget build(BuildContext context) {
    if (logo.endsWith('.svg')) {
      return Transform.flip(
        flipX: isFlip,
        child: SvgPicture.asset(logo),
      );
    } else {
      return Image.asset(logo);
    }
  }
}

class CustomImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;
  final BorderRadius? radius;
  final double? width;
  final double? height;

  const CustomImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.radius,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: radius ?? BorderRadius.zero,
      child: imageUrl.startsWith('http')
          ? Image.network(imageUrl, fit: fit, width: width, height: height)
          : Image.asset(imageUrl, fit: fit, width: width, height: height),
    );
  }
}

class CustomCircle extends StatelessWidget {
  final Color shadowColor;
  final double blurRadius;
  final double spreadRadius;
  const CustomCircle({
    super.key,
    required this.shadowColor,
    required this.blurRadius,
    required this.spreadRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 400,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: blurRadius,
            spreadRadius: spreadRadius,
          ),
        ],
      ),
    );
  }
}

class CustomText extends StatelessWidget {
  final String? text;
  final TextStyle? style;
  final TextAlign? textAlign;
  const CustomText({super.key, required this.text, this.style, this.textAlign});

  @override
  Widget build(BuildContext context) {
    return Text(text ?? '', style: style, textAlign: textAlign);
  }
}
