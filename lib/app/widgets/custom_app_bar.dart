import 'package:boost_fundr/export.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? actions;
  final bool showBackButton;
  final Widget? backWidget;

  const CustomAppBar({
    super.key,
    this.title,
    this.actions,
    this.showBackButton = true,
    this.backWidget,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
        child: Row(
          children: [
            if (backWidget != null)
              backWidget!
            else if (showBackButton)
              IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 22),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            if (showBackButton || backWidget != null) const SizedBox(width: 12),
            Expanded(
              child: title != null
                  ? Text(
                      title!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
            if (actions != null) ...actions!,
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
