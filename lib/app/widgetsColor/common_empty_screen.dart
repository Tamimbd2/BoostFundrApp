import 'package:boost_fundr/export.dart';

class CommonEmptyState extends StatelessWidget {
  const CommonEmptyState(
      {super.key, this.gif, this.image, this.message1, this.message2, this.otherWidget, this.height});

  final String? gif;
  final String? image;
  final String? message1;
  final String? message2;
  final Widget? otherWidget;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final other = otherWidget;
    return Container(
      alignment: Alignment.center,
      height: height ?? Get.height,
      padding: p24,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (gif != null) Image.asset(gif!),
          if (image != null) CustomSvgImage(logo: image!),
          if (message1 != null) gap16,
          if (message1 != null)
            CustomText(
              text: message1,
              style: context.headlineMedium.w700,
              textAlign: TextAlign.center,
            ),
          if (message2 != null) gap10,
          if (message2 != null)
            CustomText(
              text: message2,
              style: context.bodyLarge.w500.withColor(ColorConst.kGray100),
              textAlign: TextAlign.center,
            ),
          if (other != null) gap12,
          ?other,
        ],
      ),
    );
  }
}
