import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              const Positioned.fill(child: ColoredBox(color: Colors.black)),

              const Center(child: _LogoSection()),

              const Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 52),
                  child: _LoadingIndicator(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LogoSection extends StatelessWidget {
  const _LogoSection();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Image.asset(
      'assets/logo/logo.png',
      width: size.width * 0.82,
      fit: BoxFit.contain,
    );
  }
}

class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        3,
        (index) => Container(
          margin: const EdgeInsets.symmetric(vertical: 3),
          width: 5,
          height: 5,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF8DC63F).withOpacity(1 - (index * 0.28)),
          ),
        ),
      ),
    );
  }
}
