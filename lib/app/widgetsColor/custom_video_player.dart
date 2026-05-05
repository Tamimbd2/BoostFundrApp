import 'package:boost_fundr/export.dart';
// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:video_player/video_player.dart';

class CustomVideoPlayer extends StatefulWidget {
  final String videoSource;
  final bool isNetwork;
  final bool autoplay;
  final bool loop;
  final double aspectRatio;
  final String? posterUrl;
  final bool? isInFullScreen;
  final VideoPlayerController? externalController;

  const CustomVideoPlayer({
    super.key,
    required this.videoSource,
    this.isNetwork = true,
    this.autoplay = false,
    this.loop = false,
    this.aspectRatio = 16 / 9,
    this.posterUrl,
    this.isInFullScreen = false,
    this.externalController,
  });

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;
  bool _showControls = true;

  // bool _isFullScreen = false;

  // @override
  // void initState() {
  //   super.initState();
  //   _initializePlayer();
  // }
  //
  // void _initializePlayer() {
  //   _controller = widget.isNetwork
  //       ? VideoPlayerController.networkUrl(Uri.parse(widget.videoSource))
  //       : VideoPlayerController.file(File(widget.videoSource));
  //
  //   _controller.initialize().then((_) {
  //     if (widget.autoplay) _controller.play();
  //     _controller.setLooping(widget.loop);
  //     setState(() {}); // Refresh UI once video is initialized
  //   });
  //
  //   _controller.addListener(() {
  //     if (mounted) {
  //       setState(() => _isPlaying = _controller.value.isPlaying);
  //     }
  //   });
  // }
  //
  // @override
  // void dispose() {
  //   _controller.dispose();
  //   super.dispose();
  // }

  @override
  void initState() {
    super.initState();

    _controller = widget.externalController ??
        (widget.isNetwork
            ? VideoPlayerController.networkUrl(Uri.parse(widget.videoSource))
            : VideoPlayerController.file(File(widget.videoSource)));

    _initializePlayer();
  }

  void _initializePlayer() async {
    if (!_controller.value.isInitialized) {
      await _controller.initialize();
    }

    if (widget.autoplay) _controller.play();
    _controller.setLooping(widget.loop);

    _controller.addListener(() {
      if (mounted) {
        setState(() => _isPlaying = _controller.value.isPlaying);
      }
    });

    setState(() {}); // Refresh UI
  }

  @override
  void dispose() {
    if (widget.externalController == null) {
      _controller.dispose(); // 👈 Only dispose if it’s internal
    }
    super.dispose();
  }

  void _togglePlayPause() {
    _isPlaying ? _controller.pause() : _controller.play();
  }

  Future<void> _toggleFullScreen() async {
    if (widget.isInFullScreen!) {
      // Go back to normal view
      await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      Navigator.pop(context); // 👈 go back to normal view
    } else {
      // Go to fullscreen
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => Scaffold(
            backgroundColor: Colors.black,
            body: SafeArea(
              child: CustomVideoPlayer(
                videoSource: widget.videoSource,
                isNetwork: widget.isNetwork,
                autoplay: true,
                loop: widget.loop,
                aspectRatio: widget.aspectRatio,
                posterUrl: widget.posterUrl,
                isInFullScreen: true,
                externalController: _controller,
              ),
            ),
          ),
        ),
      );

      await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
  }

  void _seekVideo(Duration position) {
    _controller.seekTo(position);
  }

  void _toggleControls() {
    setState(() => _showControls = !_showControls);
  }

  double get _videoAspectRatio {
    if (_controller.value.isInitialized) {
      final size = _controller.value.size;
      return size.width / size.height;
    }
    return widget.aspectRatio; // fallback
  }

  @override
  Widget build(BuildContext context) {
    return _buildNormalView();
  }

  Widget _buildNormalView() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: _toggleControls,
      child: Stack(
        alignment: Alignment.center,
        children: [
          _controller.value.isInitialized
              ? _buildResponsiveVideo()
              : AspectRatio(
                  aspectRatio: _videoAspectRatio,
                  child: _buildPoster(),
                ),
          if (_showControls) _buildControls(),
        ],
      ),
    );
  }

  Widget _buildResponsiveVideo() {
    final videoSize = _controller.value.size;
    final isPortraitVideo = videoSize.height > videoSize.width;

    return Center(
      child: isPortraitVideo
          ? FittedBox(
              fit: BoxFit.contain,
              child: SizedBox(
                width: videoSize.width,
                height: videoSize.height,
                child: VideoPlayer(_controller),
              ),
            )
          : AspectRatio(
              aspectRatio: _videoAspectRatio,
              child: VideoPlayer(_controller),
            ),
    );
  }

  Widget _buildPoster() {
    return widget.posterUrl != null
        ? Image.network(widget.posterUrl!, fit: BoxFit.cover)
        : Container(color: Colors.black);
  }

  // Widget _buildPlayButton() {
  //   return IconButton(
  //     icon: const Icon(Icons.play_circle_fill, size: 70, color: Colors.white),
  //     onPressed: _togglePlayPause,
  //   );
  // }

  Widget _buildControls() {
    return Positioned(
      bottom: -5,
      left: 0,
      right: 0,
      child: AnimatedOpacity(
        opacity: _showControls ? 1 : 0,
        duration: const Duration(milliseconds: 300),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSeekBar(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  visualDensity: const VisualDensity(
                      horizontal: VisualDensity.minimumDensity, vertical: VisualDensity.minimumDensity),
                  padding: const EdgeInsets.symmetric(horizontal: 11),
                  icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.white),
                  onPressed: _togglePlayPause,
                ),
                IconButton(
                  padding: const EdgeInsets.symmetric(horizontal: 11),
                  visualDensity: const VisualDensity(
                      horizontal: VisualDensity.minimumDensity, vertical: VisualDensity.minimumDensity),
                  icon: Icon(widget.isInFullScreen! ? Icons.fullscreen_exit_rounded : Icons.fullscreen,
                      color: Colors.white),
                  onPressed: _toggleFullScreen,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeekBar() {
    return ValueListenableBuilder(
      valueListenable: _controller,
      builder: (context, VideoPlayerValue value, child) {
        return Slider(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          value: value.position.inSeconds.toDouble(),
          max: value.duration.inSeconds.toDouble(),
          onChanged: (v) => _seekVideo(Duration(seconds: v.toInt())),
        );
      },
    );
  }
}
