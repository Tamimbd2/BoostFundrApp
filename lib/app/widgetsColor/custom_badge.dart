import 'package:boost_fundr/export.dart';

class CustomBadge extends StatelessWidget {
  final String text;
  final Color color;
  final Color textColor;
  final double padding;

  const CustomBadge({
    super.key,
    required this.text,
    this.padding = 0,
    this.color = ColorConst.kRed,
    this.textColor = ColorConst.kWhiteColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padX((text.length == 1 || text.isEmpty) ? padding : 2),
      decoration: BoxDecoration(
        color: color,
        shape: (text.length == 1 || text.isEmpty) ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: text.length > 1 ? BorderRadius.circular(12) : null,
      ),
      constraints: const BoxConstraints(minWidth: 11, minHeight: 11),
      alignment: Alignment.center,
      child: CustomText(
        text: text,
        style: context.labelSmall.copyWith(fontSize: 8).withColor(textColor).w500,
        textAlign: TextAlign.center,
      ),
    );
  }
}
