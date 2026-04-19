import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class AdvertVediospage extends StatefulWidget {
  const AdvertVediospage({super.key});

  @override
  State<AdvertVediospage> createState() => _AdvertVediospageState();
}

class _AdvertVediospageState extends State<AdvertVediospage> {
  final PageController _pageController = PageController();

  final List<Map<String, String>> _videos = [
    {
      'videoPath': 'videos/1.mp4',
      'description':
          'Join me on a journey of tranquility and self-discovery through the ancient practice of yoga #SelfCare #Yoga...',
    },
    // {
    //   'videoPath': 'videos/2.mp4',
    //   'description':
    //       'Dancing through the fields of gold. Feeling free and alive! ✨ #Nature #Dance #Freedom',
    // },
    // {
    //   'videoPath': 'videos/3.mp4',
    //   'description':
    //       'Pushing my limits every single day. No pain, no gain. 🏋️‍♂️ #Fitness #GymLife #Motivation',
    // },
  ];

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
      body: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        itemCount: _videos.length,
        itemBuilder: (context, index) {
          return VideoCard(videoData: _videos[index]);
        },
      ),
    );
  }
}

class VideoCard extends StatefulWidget {
  final Map<String, String> videoData;
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
    _controller = VideoPlayerController.asset(widget.videoData['videoPath']!)
      ..initialize().then((_) {
        setState(() {
          _isInitialized = true;
        });
        _controller.setLooping(true);
        _controller.play();
      });

    _musicDiscController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();
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
      key: Key(widget.videoData['videoPath']!),
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
            const Center(
              child: CircularProgressIndicator(color: Color(0xffEF7044)),
            ),

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
                // Description
                Text(
                  widget.videoData['description']!,
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
}
