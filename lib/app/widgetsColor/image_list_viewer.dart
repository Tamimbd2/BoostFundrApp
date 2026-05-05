import 'package:boost_fundr/export.dart';
import './custom_video_player.dart';

class FullImageViewer extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;

  const FullImageViewer({
    super.key,
    required this.imageUrls,
    required this.initialIndex,
  });

  @override
  State<FullImageViewer> createState() => _FullImageViewerState();
}

class _FullImageViewerState extends State<FullImageViewer> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        backWidget: const SizedBox.shrink(),
        actions: [InkWell(onTap: () => Navigator.pop(context), child: const Icon(Icons.close)), gap24],
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.imageUrls.length,
              onPageChanged: (index) => setState(() => _currentIndex = index),
              itemBuilder: (context, index) {
                final url = widget.imageUrls[index];
                return url.contains('.mp4')
                    ? CustomVideoPlayer(videoSource: url)
                    : url.contains('.pdf')
                        ? Center(
                            child: ElevatedButton(
                              onPressed: () {
                                Global.openUrl(url);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorConst.kGray200,
                                padding: const EdgeInsets.symmetric(horizontal: s24, vertical: s12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(s8),
                                ),
                              ),
                              child: CustomText(text: LabelConst.openPdf),
                            ),
                          )
                        : ZoomableImage(
                            child: CustomImage(
                              imageUrl: url,
                              fit: BoxFit.contain,
                            ),
                          );
              },
            ),
          ),
          gap24,
          Container(
            margin: p24,
            height: s80,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: widget.imageUrls.length,
              separatorBuilder: (context, index) => gap4,
              itemBuilder: (context, index) {
                final url = widget.imageUrls[index];
                return GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    _pageController.jumpToPage(index);
                    setState(() => _currentIndex = index);
                  },
                  child: Container(
                    width: MediaQuery.sizeOf(context).width * .28,
                    // height: s32,
                    padding: p6,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: _currentIndex == index ? ColorConst.kGray200.withValues(alpha: 0.2) : Colors.transparent,
                    ),
                    child: url.contains('.mp4')
                        ? const Icon(Icons.play_circle_outline_outlined)
                        : CustomImage(
                            imageUrl: url,
                            fit: BoxFit.cover,
                            radius: borderRadius(8),
                            width: s80,
                          ),
                  ),
                );
              },
            ),
          ),
          gap24,
        ],
      ),
    );
  }
}

class ZoomableImage extends StatefulWidget {
  final Widget child;

  const ZoomableImage({super.key, required this.child});

  @override
  State<ZoomableImage> createState() => _ZoomableImageState();
}

class _ZoomableImageState extends State<ZoomableImage> {
  final TransformationController _transformationController = TransformationController();

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _transformationController.value = Matrix4.identity();
    return InteractiveViewer(
      panEnabled: true,
      minScale: 1.0,
      maxScale: 4.0,
      scaleEnabled: true,
      scaleFactor: 3,
      transformationController: _transformationController,
      onInteractionEnd: (_) {
        // _transformationController.value = Matrix4.identity();
      },
      child: widget.child,
    );
  }
}
