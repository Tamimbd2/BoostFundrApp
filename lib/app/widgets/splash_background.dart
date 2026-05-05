import 'package:boost_fundr/export.dart';

class SplashBackground extends StatelessWidget {
  final Widget child;

  const SplashBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // মূল কালো ব্যাকগ্রাউন্ড
          Container(color: ColorConst.kBlackColor),

          // ১. উপরের বাম দিকের গ্লোয়িং সার্কেল (Original Project Logic)
          Positioned(
            top: -64,
            left: -90,
            child: CustomCircle(
              shadowColor: ColorConst.kPrimaryColor.withValues(alpha: 0.1),
              blurRadius: 100,
              spreadRadius: 50,
            ),
          ),

          // ২. নিচের ডান দিকের গ্লোয়িং সার্কেল (Original Project Logic)
          Positioned(
            bottom: -Get.width * .8,
            right: -Get.width * .4,
            child: CustomCircle(
              blurRadius: 80,
              spreadRadius: 40,
              shadowColor: ColorConst.kPrimaryColor.withValues(alpha: 0.1),
            ),
          ),

          // লোগো বা অন্য চাইল্ড উইজেট
          child,
        ],
      ),
    );
  }
}
