import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';

class AdvertSocialMediapage extends StatefulWidget {
  const AdvertSocialMediapage({super.key});

  @override
  State<AdvertSocialMediapage> createState() => _AdvertSocialMediapageState();
}

class _AdvertSocialMediapageState extends State<AdvertSocialMediapage> {
  late final WebViewController _controller;
  bool _isLoading = true;
  double _loadingProgress = 0;
  String _activePlatform = "Facebook";

  static const Color _cardBg = Color(0xFF111827);
  static const Color _accentBlue = Color(0xFF1877F2);
  static const Color _instaPink = Color(0xFFE1306C);

  @override
  void initState() {
    super.initState();
    _initController();
  }

  void _initController() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => setState(() {
            _isLoading = true;
            _loadingProgress = 0;
          }),
          onProgress: (p) => setState(() => _loadingProgress = p / 100.0),
          onPageFinished: (_) {
            setState(() => _isLoading = false);
            if (_activePlatform == "Facebook") {
              _controller.runJavaScript('''
                var style = document.createElement('style');
                style.innerHTML = `
                  * { max-height: none !important; }
                  html, body { 
                    overflow: visible !important; 
                    height: auto !important; 
                    min-height: 100% !important;
                    -webkit-overflow-scrolling: touch !important; 
                  }
                  /* Force internal Facebook containers to expand */
                  ._2p3a, ._2p3a * { height: auto !important; max-height: none !important; }
                `;
                document.head.appendChild(style);

                // Periodic resize and scroll trigger to prompt Facebook's lazy loading
                setInterval(function() {
                  window.dispatchEvent(new Event('resize'));
                  // Subtle scroll trigger
                  window.scrollBy(0, 1);
                  window.scrollBy(0, -1);
                }, 2000);
              ''');
            }
          },
        ),
      );

    _loadContent();
  }

  // Habka Facebook looga dhigo "No Login Required" waa in loo beddelo Page Plugin HTML ah
  void _loadContent() {
    if (_activePlatform == "Facebook") {
      int fbWidth = 330;
      // Using a height of 8000 instead of 30000 to ensure it's accepted by Facebook's server
      // while still being long enough for many posts.
      final String fbUrl =
          "https://www.facebook.com/plugins/page.php?href=https%3A%2F%2Fwww.facebook.com%2Fprofile.php%3Fid%3D100068912268460&tabs=timeline&width=$fbWidth&height=8000&small_header=true&adapt_container_width=true&hide_cover=true&show_facepile=false";
      _controller.loadRequest(Uri.parse(fbUrl));
    } else if (_activePlatform == "Instagram") {
      _controller.loadRequest(
        Uri.parse("https://www.instagram.com/deeroadvert/reels/embed/"),
      );
    } else {
      _controller.loadRequest(
        Uri.parse("https://www.tiktok.com/embed/@deeroadverts"),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
            size: 20,
          ),
        ),
        title: Text(
          "Social Media Feed",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.black,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          _buildPillTabBar(screenWidth),
          const SizedBox(height: 25),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: _cardBg,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(25),
                ),
              ),
              child: Column(
                children: [
                  _buildCardHeader(),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(0),
                      ),
                      child: Stack(
                        children: [
                          WebViewWidget(
                            controller: _controller,
                            gestureRecognizers: {
                              Factory<VerticalDragGestureRecognizer>(
                                () => VerticalDragGestureRecognizer(),
                              ),
                              Factory<HorizontalDragGestureRecognizer>(
                                () => HorizontalDragGestureRecognizer(),
                              ),
                            },
                          ),
                          if (_isLoading)
                            LinearProgressIndicator(
                              value: _loadingProgress > 0
                                  ? _loadingProgress
                                  : null,
                              backgroundColor: Colors.transparent,
                              color: _activePlatform == "Instagram"
                                  ? _instaPink
                                  : _accentBlue,
                              minHeight: 2,
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPillTabBar(double width) {
    return Container(
      width: width * 0.9,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(35),
      ),
      child: Row(
        children: [
          _tabItem("Facebook", Icons.facebook, _accentBlue),
          _tabItem("Instagram", Icons.camera_alt_rounded, _instaPink),
          _tabItem("TikTok", Icons.music_note_rounded, Colors.black),
        ],
      ),
    );
  }

  Widget _tabItem(String name, IconData icon, Color color) {
    bool isActive = _activePlatform == name;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _activePlatform = name;
            _isLoading = true;
          });
          _loadContent();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? color : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 16),
              const SizedBox(width: 6),
              Text(
                name,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.white.withOpacity(0.05)),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.public, color: Colors.white70, size: 20),
          const SizedBox(width: 10),
          Text(
            "Viewing $_activePlatform",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          TextButton.icon(
            onPressed: () => _openExternal(),
            icon: const Icon(Icons.open_in_new, size: 14),
            label: const Text("Open App"),
            style: TextButton.styleFrom(foregroundColor: Colors.blueAccent),
          ),
        ],
      ),
    );
  }

  void _openExternal() {
    String url = _activePlatform == "Facebook"
        ? "https://www.facebook.com/profile.php?id=100068912268460"
        : _activePlatform == "Instagram"
        ? "https://www.instagram.com/deeroadvert/"
        : "https://www.tiktok.com/@deeroadverts";
    launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }
}
