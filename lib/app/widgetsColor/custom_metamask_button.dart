import 'package:boost_fundr/export.dart';
import 'package:reown_appkit/modal/i_appkit_modal_impl.dart';


class CustomMetamaskButton extends StatelessWidget {
  final IReownAppKitModal appKit;
  final VoidCallback? onTapped;
  final String? address;
  final bool isConnected; // NEW

  const CustomMetamaskButton({
    super.key,
    required this.appKit,
    this.onTapped,
    this.address,
    required this.isConnected,
  });

  @override
  Widget build(BuildContext context) {
    final bool isConnected = appKit.isConnected;
    final bool isError = appKit.status == ReownAppKitModalStatus.error;
    final bool isConnecting = appKit.isOpen && !isConnected;
    final bool isDisabled = !appKit.hasNamespaces || appKit.status == ReownAppKitModalStatus.initializing;

    final Color backgroundColor = isConnected
        ? ColorConst.kGreen
        : isConnecting
            ? Colors.grey
            : isError
                ? Colors.red
                : ColorConst.kMetaMaskColor;

    final String buttonText = isConnected
        ? LabelConst.connectedToMetamask
        : isConnecting
            ? LabelConst.connectingToMetamask
            : isError
                ? LabelConst.connectionFailed
                : LabelConst.connectToMetamask;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton(
          onPressed: (isDisabled || isConnecting) ? null : onTapped,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            padding: py8,
            shape: const RoundedRectangleBorder(borderRadius: borderRadius8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CustomSvgImage(logo: ImageConst.icMetamask),
              gap12,
              if (isConnecting)
                const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                )
              else
                CustomText(text: buttonText, style: context.bodyLarge.w600),
            ],
          ),
        ),
        if (isConnected)
          Row(
            children: [
              const CustomSvgImage(logo: ImageConst.icCheck),
              gap8,
              Expanded(
                child: Text(
                  address ?? LabelConst.addressNotFound,
                  style: context.bodyMedium.w400.copyWith(color: ColorConst.kGray100),
                ),
              ),
            ],
          ).paddingOnly(top: 12),
      ],
    );
  }
}

// class CustomMetamaskButton extends StatelessWidget {
//   final bool isConnected;
//   final void Function()? onTapped;
//
//   const CustomMetamaskButton({super.key, this.isConnected = false, this.onTapped});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       mainAxisSize: MainAxisSize.min,
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: [
//         ElevatedButton(
//           onPressed: onTapped,
//           style: ElevatedButton.styleFrom(
//               backgroundColor: isConnected ? ColorConst.kGreen : ColorConst.kMetaMaskColor,
//               padding: py8,
//               shape: const RoundedRectangleBorder(
//                   side: BorderSide(color: Colors.transparent), borderRadius: borderRadius8)),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               const CustomSvgImage(logo: ImageConst.icMetamask),
//               gap12,
//               CustomText(
//                 text: isConnected ? LabelConst.connectedToMetamask : LabelConst.connectToMetamask,
//                 style: context.bodyLarge.w600,
//               ),
//             ],
//           ),
//         ),
//         isConnected
//             ? Row(
//                 spacing: s10,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   const CustomSvgImage(logo: ImageConst.icCheck),
//                   Text(
//                     LabelConst.connectToMetamaskSuccess,
//                     style: context.bodyLarge.w400.copyWith(
//                       color: ColorConst.kGray100,
//                     ),
//                     textHeightBehavior:
//                         const TextHeightBehavior(applyHeightToFirstAscent: false, applyHeightToLastDescent: false),
//                   ).expanded()
//                 ],
//               ).paddingOnly(top: 14)
//             : const SizedBox.shrink()
//       ],
//     );
//   }
// }
