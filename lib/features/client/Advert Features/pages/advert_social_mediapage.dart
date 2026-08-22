import 'package:deero_advert_app/core/constant.dart';
import 'package:deero_advert_app/core/safe_url.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdvertSocialMediapage extends StatelessWidget {
  const AdvertSocialMediapage({super.key});

  static const _facebookUrl =
      'https://www.facebook.com/profile.php?id=100068912268460';

  Future<void> _open(BuildContext context, String url) async {
    final opened = await launchSafeExternalUrl(url);
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open this trusted link')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final platforms = <_SocialPlatform>[
      const _SocialPlatform(
        name: 'Facebook',
        description: 'View our official Facebook page',
        url: _facebookUrl,
        icon: Icons.facebook,
        color: Color(0xFF1877F2),
      ),
      _SocialPlatform(
        name: 'Instagram',
        description: 'View our latest Instagram posts and reels',
        url: kAdvertSocialInstagramUrl,
        icon: Icons.camera_alt_rounded,
        color: const Color(0xFFE1306C),
      ),
      _SocialPlatform(
        name: 'TikTok',
        description: 'Watch Deero Advert on TikTok',
        url: kAdvertSocialTikTokUrl,
        icon: Icons.music_note_rounded,
        color: Colors.black,
      ),
      _SocialPlatform(
        name: 'LinkedIn',
        description: 'Connect with our company on LinkedIn',
        url: kAdvertSocialLinkedInUrl,
        icon: Icons.business_rounded,
        color: const Color(0xFF0A66C2),
      ),
      _SocialPlatform(
        name: 'Behance',
        description: 'Explore our creative portfolio',
        url: kAdvertSocialBehanceUrl,
        icon: Icons.palette_rounded,
        color: const Color(0xFF1769FF),
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        ),
        title: Text(
          'Social Media',
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Follow Deero Advert',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Social content opens securely in the official app or browser.',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: const Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 24),
          for (final platform in platforms)
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                child: InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: () => _open(context, platform.url),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: platform.color,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(platform.icon, color: Colors.white),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                platform.name,
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                platform.description,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: const Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.open_in_new_rounded, size: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SocialPlatform {
  final String name;
  final String description;
  final String url;
  final IconData icon;
  final Color color;

  const _SocialPlatform({
    required this.name,
    required this.description,
    required this.url,
    required this.icon,
    required this.color,
  });
}
