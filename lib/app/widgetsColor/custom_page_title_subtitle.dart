import 'package:boost_fundr/export.dart';

class CustomPageTitleText extends StatelessWidget {
  final String title;
  final String? subtitle;

  const CustomPageTitleText({super.key, required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: title,
          style: context.displayLarge.copyWith(
            fontSize: 28,
          ),
        ),
        if (subtitle != null && subtitle != "") gap12,
        if (subtitle != null && subtitle != "")
          CustomText(text: subtitle!, style: context.headlineMedium.w500.copyWith(color: ColorConst.kGray100)),
      ],
    );
  }
}
