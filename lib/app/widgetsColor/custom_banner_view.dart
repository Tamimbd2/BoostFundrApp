import 'package:boost_fundr/export.dart';
import './custom_video_player.dart';


class BannerList extends StatefulWidget {
  final List<String> imageList;
  final Function(int) onBannerTap;
  final bool authPlay;
  final double aspectRatio;
  final Color selectedColor;
  final Color unselectedColor;
  final double radius;

  const BannerList({
    super.key,
    required this.imageList,
    required this.onBannerTap,
    this.aspectRatio = bannerRatio,
    this.selectedColor = ColorConst.kPrimaryColor,
    this.unselectedColor = ColorConst.kGray100,
    this.radius = 0,
    this.authPlay = false,
  });

  @override
  State<BannerList> createState() => _BannerListState();
}

class _BannerListState extends State<BannerList> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
    // widget.authPlay ? _startAutoSlide() : null;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // void _startAutoSlide() {
  //   Future.delayed(const Duration(seconds: 3), () {
  //     Logger.printer(title: "dsfsfadsfads");
  //     if (!mounted) return;
  //     if (_pageController.hasClients && _pageController.page != 0) {
  //       _currentIndex = (_currentIndex + 1) % widget.imageList.length;
  //       _animatePage();
  //     }
  //     _startAutoSlide();
  //   });
  // }

  void _animatePage() {
    _pageController.animateToPage(_currentIndex, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: widget.aspectRatio,
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.imageList.length,
            onPageChanged: (index) {
              _currentIndex = index;
              _animatePage();
            },
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () => widget.onBannerTap(index),
                child: widget.imageList[index].contains('.mp4')
                    ? CustomVideoPlayer(videoSource: widget.imageList[index])
                    : CustomImage(
                        imageUrl: widget.imageList[index],
                        fit: BoxFit.cover,
                        radius: borderRadius(widget.radius),
                      ),
              );
            },
          ),
          Container(
            margin: p12,
            padding: padXY(s12, s2),
            decoration: const BoxDecoration(shape: BoxShape.rectangle, color: ColorConst.kLightGray),
            child: CustomText(text: '${_currentIndex + 1}/${widget.imageList.length}'),
          ),
        ],
      ),
    );
  }
}
