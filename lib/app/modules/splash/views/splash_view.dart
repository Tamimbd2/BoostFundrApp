import 'package:boost_fundr/export.dart';
import '../controllers/splash_controller.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    // কন্ট্রোলার থেকে নেভিগেশন লজিক কল করা
    SplashController.to.checkNavigation();
    
    // স্ট্যাটাস বার কালো করা
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.black, 
        statusBarColor: Colors.black
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SplashBackground(
      child: Center(
        child: Padding(
          padding: padXY(40, 0),
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 1500),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.scale(
                  scale: 0.85 + (0.15 * value),
                  child: child,
                ),
              );
            },
            child: const CustomSvgImage(
              logo: ImageConst.icAppLogo2,
              isFlip: false,
            ),
          ),
        ),
      ),
    );
  }
}
