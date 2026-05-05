import 'package:boost_fundr/export.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;

  const GradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Base Black Background
        Container(
          color: Colors.black,
        ),
        
        // Top Left Glow
        Positioned(
          top: -100,
          left: -100,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF22C55E).withValues(alpha: 0.08),
                  blurRadius: 150,
                  spreadRadius: 50,
                ),
              ],
            ),
          ),
        ),
        
        // Center/Bottom Right Glow
        Positioned(
          bottom: -150,
          right: -100,
          child: Container(
            width: 400,
            height: 400,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF22C55E).withValues(alpha: 0.05),
                  blurRadius: 200,
                  spreadRadius: 80,
                ),
              ],
            ),
          ),
        ),
        
        // Content
        child,
      ],
    );
  }
}
