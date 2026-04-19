import 'package:deero_enterprise_app/core/constant.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

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
      'handle': '@DeeroInstitute',
      'url': kAdvertSocialFacebookUrl,
      'icon': LineIcons.facebook,
      'color': const Color(0xFF1877F2),
    },
    {
      'name': 'TikTok',
      'handle': '@deeroinstitute',
      'url': kAdvertSocialTikTokUrl,
      'icon': LineIcons.music,
      'color': Colors.black,
    },
    {
      'name': 'Instagram',
      'handle': '@deero_advert',
      'url': kAdvertSocialInstagramUrl,
      'icon': LineIcons.instagram,
      'color': const Color(0xFFE1306C),
    },
    {
      'name': 'WhatsApp',
      'handle': '+252 61 8553566',
      'url': 'https://wa.me/252618553566',
      'icon': LineIcons.whatSApp,
      'color': const Color(0xFF25D366),
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() => _isLoading = true);
          },
          onPageFinished: (String url) {
            setState(() => _isLoading = false);
            // Hide headers/footers to keep it clean
            _controller.runJavaScript('''
              (function() {
                var selectors = [
                  'header', 'nav', '.header', '.top-bar', 
                  '._aa_c', '._as_f', 
                  '.tiktok-p9p6ia-DivHeaderContainer',
                  '.global-nav'
                ];
                selectors.forEach(function(selector) {
                  var elements = document.querySelectorAll(selector);
                  elements.forEach(function(el) { el.style.display = 'none'; });
                });
              })();
            ''');
          },
        ),
      );
    _loadPage(0);
  }

  void _loadPage(int index) {
    String url = _platforms[index]['url'];
    if (url.contains('facebook.com')) {
      final String facebookEmbedHtml =
          '''
        <!DOCTYPE html>
        <html>
        <head>
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <style> body { margin: 0; padding: 0; background-color: #fff; } </style>
        </head>
        <body>
          <div id="fb-root"></div>
          <script async defer crossorigin="anonymous" src="https://connect.facebook.net/en_US/sdk.js#xfbml=1&version=v18.0"></script>
          <div class="fb-page" data-href="$url" data-tabs="timeline" data-width="500" data-small-header="false" data-adapt-container-width="true" data-hide-cover="false"></div>
        </body>
        </html>
      ''';
      _controller.loadHtmlString(facebookEmbedHtml);
    } else {
      _controller.loadRequest(Uri.parse(url));
    }
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color currentPlatformColor = _platforms[_selectedIndex]['color'];

    return Scaffold(
      backgroundColor: const Color(0xFFF3F6F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
            size: 20,
          ),
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Top Tabs
            _buildTopTabs(),
            const SizedBox(height: 24),
            // Main Feed Card
            _buildFeedCard(currentPlatformColor),
            const SizedBox(height: 30),
            // Footer
            _buildFooter(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildTopTabs() {
    return Container(
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _platforms.length,
        itemBuilder: (context, index) {
          bool isSelected = _selectedIndex == index;
          return GestureDetector(
            onTap: () {
              setState(() => _selectedIndex = index);
              _loadPage(index);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: isSelected ? _platforms[index]['color'] : Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: isSelected ? Colors.transparent : Colors.grey.shade300,
                ),
              ),
              child: Center(
                child: Row(
                  children: [
                    Icon(
                      _platforms[index]['icon'],
                      size: 18,
                      color: isSelected ? Colors.white : Colors.black54,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _platforms[index]['name'],
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black54,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeedCard(Color platformColor) {
    var platform = _platforms[_selectedIndex];
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Card Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: platformColor.withOpacity(0.1),
                  child: Icon(platform['icon'], color: platformColor, size: 20),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      platform['name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      platform['handle'],
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () => _launchUrl(platform['url']),
                  icon: const Icon(Icons.open_in_new, size: 14),
                  label: const Text(
                    "View",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1877F2),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // WebView Content
          SizedBox(
            height: 450,
            child: Stack(
              children: [
                WebViewWidget(controller: _controller),
                if (_isLoading)
                  const Center(
                    child: CircularProgressIndicator(color: Color(0xFF1877F2)),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        const Text(
          "Connect with us on social media",
          style: TextStyle(
            color: Colors.black54,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _FooterButton(
              icon: LineIcons.facebook,
              label: "Facebook",
              onTap: () => _launchUrl(kAdvertSocialFacebookUrl),
            ),
            const SizedBox(width: 15),
            _FooterButton(
              icon: LineIcons.twitter,
              label: "X",
              onTap: () => _launchUrl('https://twitter.com/deeroinstitute'),
            ),
          ],
        ),
      ],
    );
  }
}

class _FooterButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _FooterButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
