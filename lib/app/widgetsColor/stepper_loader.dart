import 'package:boost_fundr/export.dart';


class StepLoaderDialog extends StatelessWidget {
  final int currentStep;

  const StepLoaderDialog({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    final steps = [
      'Approving Contract',
      'Sending Investment',
      'Updating Backend',
    ];

    return Dialog(
      insetPadding: p24,
      backgroundColor: ColorConst.kGray400,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: p24,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(steps.length, (index) {
            final isCompleted = index < currentStep;
            final isCurrent = index == currentStep;
            return Row(
              children: [
                isCompleted
                    ? const Icon(Icons.check_circle, color: ColorConst.kPrimaryColor)
                    : isCurrent
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.radio_button_unchecked, color: ColorConst.kWhiteColor),
                gap12,
                CustomText(
                  text: steps[index],
                  style: context.bodyLarge.w500.copyWith(
                    fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                    color: isCompleted ? ColorConst.kPrimaryColor : ColorConst.kWhiteColor,
                  ),
                ),
              ],
            ).paddingSymmetric(vertical: s12);
          }),
        ),
      ),
    );
  }
}

Future<void> showStepLoader({required RxInt step}) async {
  Get.dialog(
    Obx(() => StepLoaderDialog(currentStep: step.value)),
    barrierDismissible: false,
  );
}
