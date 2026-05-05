
import 'dart:io';
import 'package:boost_fundr/export.dart';


class CustomUploadWidget extends StatelessWidget {
  final List<String> allowedFileFormats; // Allow multiple file formats
  final String title;
  final String subTitle;
  final List<File> files;
  final int maxFiles;
  final VoidCallback onUploadTap;
  final void Function(File file) onPreviewTap;
  final void Function(int index) onRemoveTap;

  const CustomUploadWidget({
    super.key,
    this.allowedFileFormats = const [".png", ".pdf"],
    required this.title,
    required this.subTitle,
    required this.files,
    this.maxFiles = 2,
    required this.onUploadTap,
    required this.onPreviewTap,
    required this.onRemoveTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: context.bodyMedium.w600),
        gap4,
        Text(subTitle, style: context.bodySmall.w500),
        gap10,
        if (files.isNotEmpty)
          ListView.separated(
            itemBuilder: (context, index) {
              var file = files[index];
              return Row(
                children: [
                  file.path.endsWith('.png') || file.path.endsWith('.jpg') || file.path.endsWith('.jpeg')
                      ? ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.file(file, fit: BoxFit.cover))
                      : const Center(
                          child: CustomSvgImage(logo: ImageConst.icUploadPlus),
                        ),
                  gap8,
                  CustomText(
                    text: file.path,
                    style: context.bodyLarge.w400,
                  ),
                  const Spacer(),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () => onRemoveTap(index),
                    child: const CircleAvatar(
                      radius: 10,
                      backgroundColor: ColorConst.kRedColor,
                      child: Icon(
                        Icons.close,
                        size: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              );
            },
            separatorBuilder: (BuildContext context, int index) => const Divider(
              color: ColorConst.kGray500,
            ),
            itemCount: files.length,
          ),
        if (files.length < maxFiles)
          GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: onUploadTap,
              child: const CustomSvgImage(logo: ImageConst.icPotCircleFill)),
      ],
    );
  }
}
