import 'package:deero_enterprise_app/features/client/Advert%20Features/controllers/video_provider.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/models/video_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class AdvertVediospage extends StatefulWidget {
  const AdvertVediospage({super.key});

  @override
  State<AdvertVediospage> createState() => _AdvertVediospageState();
}

class _AdvertVediospageState extends State<AdvertVediospage> {
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<VideoProvider>(context, listen: false).getVideos();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      body: Consumer<VideoProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return _buildGlobalShimmer();
          }

          if (provider.error.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.white54,
                    size: 40,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    provider.error,
                    style: GoogleFonts.poppins(color: Colors.white70),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => provider.getVideos(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffEF7044),
                    ),
                    child: const Text(
                      "Retry",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          }

          final videos = provider.videoModel?.data ?? [];

          if (videos.isEmpty) {
            return Center(
              child: Text(
                "No videos available",
                style: GoogleFonts.poppins(color: Colors.white70),
              ),
            );
          }

          return PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            itemCount: videos.length,
            itemBuilder: (context, index) {
              return VideoCard(videoData: videos[index]);
            },
          );
        },
      ),
    );
  }

  Widget _buildGlobalShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[900]!,
      highlightColor: Colors.grey[800]!,
      child: PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: 3,
        itemBuilder: (context, index) {
          return Stack(
            fit: StackFit.expand,
            children: [
              Container(color: Colors.black),
              Positioned(
                left: 16,
                bottom: 30,
                right: 100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          width: 120,
                          height: 15,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Container(
                      width: double.infinity,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 200,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class VideoCard extends StatefulWidget {
  final VideoData videoData;
  const VideoCard({super.key, required this.videoData});

  @override
  State<VideoCard> createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard>
    with SingleTickerProviderStateMixin {
  late VideoPlayerController _controller;
  late AnimationController _musicDiscController;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initVideo();

    _musicDiscController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();
  }

  void _initVideo() {
    if (widget.videoData.url == null) return;

    _controller =
        VideoPlayerController.networkUrl(Uri.parse(widget.videoData.url!))
          ..initialize()
              .then((_) {
                if (!mounted) return;
                setState(() {
                  _isInitialized = true;
                });
                _controller.setLooping(true);
                _controller.play();
              })
              .catchError((e) {
                print("Video initialize error: $e");
              });
  }

  @override
  void dispose() {
    _controller.dispose();
    _musicDiscController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(widget.videoData.url ?? widget.videoData.id ?? ""),
      onVisibilityChanged: (info) {
        if (!mounted) return;
        if (info.visibleFraction > 0.5) {
          _controller.play();
          _musicDiscController.repeat();
        } else {
          _controller.pause();
          _musicDiscController.stop();
        }
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Video Player
          if (_isInitialized)
            GestureDetector(
              onTap: () {
                if (_controller.value.isPlaying) {
                  _controller.pause();
                } else {
                  _controller.play();
                }
                setState(() {});
              },
              onDoubleTapDown: (details) {
                // Double tap to seek
                final width = MediaQuery.of(context).size.width;
                final dx = details.localPosition.dx;
                if (dx < width / 2) {
                  // Left side - Backward 10s
                  _seekRelative(const Duration(seconds: -10));
                } else {
                  // Right side - Forward 10s
                  _seekRelative(const Duration(seconds: 10));
                }
              },
              child: SizedBox.expand(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _controller.value.size.width,
                    height: _controller.value.size.height,
                    child: VideoPlayer(_controller),
                  ),
                ),
              ),
            )
          else
            _buildCardShimmer(),

          // Video Progress Bar (Seekbar)
          if (_isInitialized)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: VideoProgressIndicator(
                _controller,
                allowScrubbing: true,
                colors: const VideoProgressColors(
                  playedColor: Color(0xffEF7044),
                  bufferedColor: Colors.white24,
                  backgroundColor: Colors.white10,
                ),
                padding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),

          // Forward/Backward Indicators (Overlay)
          // These show up when seeking

          // Top Header Overlay
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Video",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Info Section
          Positioned(
            left: 16,
            bottom: 30,
            right: 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User Profile & Follow
                Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundImage: AssetImage(
                        "images/advertimages/DeeroAdvertLogoicon.png",
                      ),
                      backgroundColor: Colors.white,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "Deero Advert",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                // Description (Title from backend)
                Text(
                  widget.videoData.title ?? "",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Pause Overlay
          if (!_controller.value.isPlaying && _isInitialized)
            Center(
              child: Icon(
                Icons.play_arrow_rounded,
                size: 100,
                color: Colors.white.withOpacity(0.5),
              ),
            ),
        ],
      ),
    );
  }

  void _seekRelative(Duration relative) {
    final currentPosition = _controller.value.position;
    final newPosition = currentPosition + relative;
    _controller.seekTo(newPosition);

    // Show a quick snackbar or overlay feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(relative.inSeconds > 0 ? "+10s" : "-10s"),
        duration: const Duration(milliseconds: 500),
        behavior: SnackBarBehavior.floating,
        width: 60,
      ),
    );
  }

  Widget _buildCardShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[900]!,
      highlightColor: Colors.grey[800]!,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(color: Colors.black),
          Center(
            child: Icon(
              Icons.play_arrow_rounded,
              size: 80,
              color: Colors.white.withOpacity(0.2),
            ),
          ),
        ],
      ),
    );
  }
}
