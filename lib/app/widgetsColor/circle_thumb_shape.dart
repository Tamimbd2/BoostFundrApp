import 'package:boost_fundr/export.dart';


class CircleThumbShape extends RangeSliderThumbShape {
  const CircleThumbShape({this.thumbRadius = 13.0});

  final double thumbRadius;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required SliderThemeData sliderTheme,
    bool? isDiscrete,
    bool? isEnabled,
    bool? isOnTop,
    TextDirection? textDirection,
    Thumb? thumb,
    bool? isPressed,
  }) {
    final Canvas canvas = context.canvas;

    Path path = Path()
      ..addOval(Rect.fromCircle(center: center, radius: 13 - 2))
      ..fillType = PathFillType.evenOdd;

    final Paint fillPaint = Paint()
      ..color = ColorConst.kPrimaryColor
      ..style = PaintingStyle.fill;

    final Paint borderPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    canvas
      ..drawPath(path, Paint()..color = ColorConst.kPrimaryColor)
      ..drawCircle(center, thumbRadius, fillPaint)
      ..drawCircle(center, thumbRadius, borderPaint);
  }
}
