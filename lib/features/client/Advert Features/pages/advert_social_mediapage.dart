import 'package:deero_enterprise_app/core/constant.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:line_icons/line_icons.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AdvertSocialMediapage extends StatefulWidget {
  const AdvertSocialMediapage({super.key});

  @override
  State<AdvertSocialMediapage> createState() => _AdvertSocialMediapageState();
}

class _AdvertSocialMediapageState extends State<AdvertSocialMediapage> {
  int _selectedIndex = 0;
  late final WebViewController _controller;
  bool _isLoading = true;

  final List<Map<String, dynamic>> _platforms = [
    {
      'name': 'Facebook',
      'url': kAdvertSocialFacebookUrl,
      'icon': LineIcons.facebook,
      'color': const Color(0xFF1877F2),
    },
    {
      'name': 'TikTok',
      'url': kAdvertSocialTikTokUrl,
      'icon': LineIcons.music,
      'color': Colors.black,
    },
    {
      'name': 'Instagram',
      'url': kAdvertSocialInstagramUrl,
      'icon': LineIcons.instagram,
      'color': const Color(0xFFE1306C),
    },
    {
      'name': 'LinkedIn',
      'url': kAdvertSocialLinkedInUrl,
      'icon': LineIcons.linkedin,
      'color': const Color(0xFF0077B5),
    },
    {
      'name': 'Behance',
      'url': kAdvertSocialBehanceUrl,
      'icon': LineIcons.behance,
      'color': const Color(0xFF1769FF),
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
            // Inject JS to hide headers and focus on feed
            _controller.runJavaScript('''
              (function() {
                var selectors = [
                  'header', 'nav', '.header', '.top-bar', 
                  '._aa_c', '._as_f', // Instagram headers
                  '.tiktok-p9p6ia-DivHeaderContainer', // TikTok header
                  '.tiktok-1g089v2-DivProfileHeader', // TikTok profile info
                  '.global-nav', // LinkedIn
                  '#global-nav'
                ];
                selectors.forEach(function(selector) {
                  var elements = document.querySelectorAll(selector);
                  elements.forEach(function(el) {
                    el.style.display = 'none';
                  });
                });
                // Optional: Adjust padding/margin after hiding
                document.body.style.paddingTop = '0px';
                document.body.style.marginTop = '0px';
              })();
            ''');
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) async {
            final String url = request.url;
            if (!url.startsWith('http://') && !url.startsWith('https://')) {
              // Handle deep links (e.g., snssdk1340://) with url_launcher
              final Uri uri = Uri.parse(url);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
                return NavigationDecision.prevent;
              }
            }
            return NavigationDecision.navigate;
          },
        ),
      );
    _loadPage(0);
  }

  void _loadPage(int index) {
    String url = _platforms[index]['url'];

    // For Facebook, use the Page Plugin for a better feed look
    if (url.contains('facebook.com')) {
      final String facebookEmbedHtml =
          '''
        <!DOCTYPE html>
        <html>
        <head>
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <style>
            body { margin: 0; padding: 0; display: flex; justify-content: center; background-color: #f0f2f5; }
            .fb-page-container { width: 100%; height: 100vh; overflow-y: auto; }
          </style>
        </head>
        <body>
          <div id="fb-root"></div>
          <script async defer crossorigin="anonymous" src="https://connect.facebook.net/en_US/sdk.js#xfbml=1&version=v18.0" nonce="abc"></script>
          <div class="fb-page" 
               data-href="$url" 
               data-tabs="timeline" 
               data-width="500" 
               data-height="1000" 
               data-small-header="false" 
               data-adapt-container-width="true" 
               data-hide-cover="false" 
               data-show-facepile="true">
            <blockquote cite="$url" class="fb-xfbml-parse-ignore">
              <a href="$url">Deero Advert</a>
            </blockquote>
          </div>
        </body>
        </html>
      ''';
      _controller.loadHtmlString(facebookEmbedHtml);
    } else {
      _controller.loadRequest(Uri.parse(url));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: Text(
          "Social Media",
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          // Platforms Tabs
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _platforms.length,
              itemBuilder: (context, index) {
                bool isSelected = _selectedIndex == index;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIndex = index;
                    });
                    _loadPage(index);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? _platforms[index]['color']
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _platforms[index]['icon'],
                          size: 16,
                          color: isSelected
                              ? Colors.white
                              : Colors.grey.shade600,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _platforms[index]['name'],
                          style: GoogleFonts.poppins(
                            color: isSelected
                                ? Colors.white
                                : Colors.grey.shade600,
                            fontSize: 13,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          // WebView Container
          Expanded(
            child: Stack(
              children: [
                WebViewWidget(controller: _controller),
                if (_isLoading)
                  Container(
                    color: Colors.white,
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xffEF7044),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
