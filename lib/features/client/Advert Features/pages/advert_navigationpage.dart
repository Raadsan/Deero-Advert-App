import 'package:deero_advert_app/core/constant.dart';
import 'package:deero_advert_app/core/widgets/safe_network_image.dart';
import 'package:deero_advert_app/core/themes/color_page.dart';
import 'package:deero_advert_app/features/auth/controllers/user_provider.dart';
import 'package:deero_advert_app/features/client/Advert%20Features/controllers/chat_provider.dart';
import 'package:deero_advert_app/features/client/Advert%20Features/controllers/navigation_provider.dart';
import 'package:deero_advert_app/features/client/Advert%20Features/pages/advert_chat_main_navigation.dart';
import 'package:deero_advert_app/features/client/Advert%20Features/pages/advert_homepage.dart';
import 'package:deero_advert_app/features/client/Advert%20Features/pages/advert_hostingpage.dart';
import 'package:deero_advert_app/features/client/Advert%20Features/pages/advert_profilepage.dart';
import 'package:deero_advert_app/features/client/Advert%20Features/pages/advert_chat_list_page.dart';
import 'package:deero_advert_app/features/client/Advert%20Features/pages/advert_servicepage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/services.dart';
import 'dart:io';

class AdvertNavigationpage extends StatefulWidget {
  AdvertNavigationpage({super.key});

  @override
  State<AdvertNavigationpage> createState() => _AdvertNavigationpageState();
}

class _AdvertNavigationpageState extends State<AdvertNavigationpage> {
  bool _socialFabOpen = false;

  // Keep tab pages alive so Homepage does not re-fetch on every tab switch
  late final Widget _homePage = const AdvertHomepage();
  late final Widget _chatPage = const AdvertChatListPage();
  late final Widget _hostingPage = AdvertHostingpage();
  late final Widget _profilePage = const AdvertProfilePage();
  int _cachedServiceIndex = 0;
  late Widget _servicePage = AdvertServicepage(
    key: ValueKey('service-$_cachedServiceIndex'),
    initialIndex: _cachedServiceIndex,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final chatProvider = Provider.of<ChatProvider>(context, listen: false);
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      if (userProvider.userModel?.user != null) {
        int currentUserId =
            int.tryParse(userProvider.userModel!.user!.id.toString()) ?? -1;
        chatProvider.connectSocket(currentUserId);
        chatProvider.fetchConversations();
      }
    });
  }

  List<Widget> _pagesFor(int serviceIndex) {
    if (serviceIndex != _cachedServiceIndex) {
      _cachedServiceIndex = serviceIndex;
      _servicePage = AdvertServicepage(
        key: ValueKey('service-$serviceIndex'),
        initialIndex: serviceIndex,
      );
    }
    return [
      _homePage,
      _servicePage,
      _chatPage,
      _hostingPage,
      _profilePage,
    ];
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Could not open link")));
      }
    }
  }

  Future<void> _openInstagram() async {
    if (!await launchUrl(
      Uri.parse(kAdvertSocialInstagramUrl),
      mode: LaunchMode.externalApplication,
    )) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Could not open Instagram")),
        );
      }
    }
  }

  Future<void> _openlinkedin() async {
    if (!await launchUrl(
      Uri.parse(kAdvertSocialLinkedInUrl),
      mode: LaunchMode.externalApplication,
    )) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Could not open Linkedin")),
        );
      }
    }
  }

  Widget _miniSocialButton({
    IconData? icon,
    String? imagePath,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: color,
        elevation: 4,
        shadowColor: Colors.black26,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () {
            onTap();
            setState(() => _socialFabOpen = false);
          },
          child: SizedBox(
            width: 48,
            height: 48,
            child: Center(
              child: imagePath != null
                  ? Image.asset(imagePath, width: 28, height: 28)
                  : Icon(icon, color: Colors.white, size: 22),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildPages(int serviceIndex) => _pagesFor(serviceIndex);

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationProvider>(
      builder: (context, navProvider, _) {
        final userProvider = Provider.of<UserProvider>(context);
        final userRole =
            userProvider.userModel?.user?.role?.name?.toLowerCase() ?? 'user';

        // If not a regular 'user' (Admin/Staff), show the simplified chat navigation
        if (userRole != 'user') {
          return const AdvertChatMainNavigation();
        }

        // Regular users get the full navigation
        final pages = _buildPages(navProvider.serviceInitialIndex);

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            systemNavigationBarColor: bgColor,
            systemNavigationBarIconBrightness: Brightness.dark,
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
          ),
          child: PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) async {
              if (didPop) return;

              if (navProvider.currentIndex != 0) {
                // Redirect to Home if not already there
                navProvider.setPageIndex(0);
              } else {
                // Show beautiful exit dialog
                _showExitDialog(context);
              }
            },
            child: Scaffold(
              body: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (MediaQuery.sizeOf(context).width >= 840)
                    Container(
                      width: MediaQuery.sizeOf(context).width >= 1200
                          ? 220
                          : 200,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFF660E0D), Color(0xFF962719)],
                        ),
                      ),
                      child: SafeArea(
                        right: false,
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 28,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  14,
                                  0,
                                  14,
                                  28,
                                ),
                                child: Text(
                                  'DEERO',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ),
                              _buildNavItem(
                                index: 0,
                                icon: IconlyLight.home,
                                activeIcon: IconlyBold.home,
                                label: 'Home',
                                navProvider: navProvider,
                              ),
                              const SizedBox(height: 10),
                              _buildNavItem(
                                index: 1,
                                icon: IconlyLight.category,
                                activeIcon: IconlyBold.category,
                                label: 'Service',
                                navProvider: navProvider,
                              ),
                              const SizedBox(height: 10),
                              _buildNavItem(
                                index: 2,
                                icon: IconlyLight.chat,
                                activeIcon: IconlyBold.chat,
                                label: 'Chat',
                                navProvider: navProvider,
                              ),
                              const SizedBox(height: 10),
                              _buildHostingNavItem(
                                index: 3,
                                label: 'Hosting',
                                navProvider: navProvider,
                              ),
                              const SizedBox(height: 10),
                              _buildProfileNavItem(
                                index: 4,
                                label: 'Profile',
                                navProvider: navProvider,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  Expanded(
                    child: IndexedStack(
                      index: navProvider.currentIndex,
                      children: pages,
                    ),
                  ),
                ],
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.endFloat,
              floatingActionButton: navProvider.currentIndex == 2
                  ? null
                  : Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (_socialFabOpen) ...[
                            _miniSocialButton(
                              icon: LineIcons.whatSApp,
                              color: const Color(0xFF25D366),
                              onTap: () => _openUrl(kAdvertSocialWhatsAppUrl),
                            ),
                            _miniSocialButton(
                              icon: LineIcons.music,
                              imagePath: "images/advertimages/tiktok.png",
                              color: const Color(0xFF000000),
                              onTap: () => _openUrl(kAdvertSocialTikTokUrl),
                            ),
                            _miniSocialButton(
                              icon: LineIcons.behance,
                              color: const Color(0xFF1769FF),
                              onTap: () => _openUrl(kAdvertSocialBehanceUrl),
                            ),
                            _miniSocialButton(
                              icon: LineIcons.instagram,
                              color: const Color(
                                0xFFE1306C,
                              ), // Official Instagram Magenta
                              onTap: _openInstagram,
                            ),
                            _miniSocialButton(
                              icon: LineIcons.linkedin,
                              color: const Color(
                                0xFF0072B1,
                              ), // Official Instagram Magenta
                              onTap: _openlinkedin,
                            ),
                          ],
                          FloatingActionButton(
                            onPressed: () => setState(
                              () => _socialFabOpen = !_socialFabOpen,
                            ),
                            backgroundColor: const Color(0xffEF7044),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(60),
                            ),
                            child: Icon(
                              _socialFabOpen
                                  ? IconlyLight.chat
                                  : IconlyLight.chat,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        ],
                      ),
                    ),
              bottomNavigationBar: MediaQuery.sizeOf(context).width >= 840
                  ? null
                  : Container(
                      decoration: BoxDecoration(
                        color: bgColor,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 20,
                            color: Colors.black.withOpacity(.1),
                          ),
                        ],
                      ),
                      child: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10.0,
                            vertical: 8,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildNavItem(
                                index: 0,
                                icon: IconlyLight.home,
                                activeIcon: IconlyBold.home,
                                label: 'Home',
                                navProvider: navProvider,
                              ),
                              _buildNavItem(
                                index: 1,
                                icon: IconlyLight.category,
                                activeIcon: IconlyBold.category,
                                label: 'Service',
                                navProvider: navProvider,
                              ),
                              _buildNavItem(
                                index: 2,
                                icon: IconlyLight.chat,
                                activeIcon: IconlyBold.chat,
                                label: 'Chat',
                                navProvider: navProvider,
                              ),
                              _buildHostingNavItem(
                                index: 3,
                                label: 'Hosting',
                                navProvider: navProvider,
                              ),
                              _buildProfileNavItem(
                                index: 4,
                                label: 'Profile',
                                navProvider: navProvider,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }

  Widget _navigationTile({
    required int index,
    required NavigationProvider navProvider,
    required List<Widget> children,
  }) {
    final wide = MediaQuery.sizeOf(context).width >= 840;
    final selected = navProvider.currentIndex == index;
    return Semantics(
      selected: selected,
      button: true,
      child: Material(
        color: wide && selected ? const Color(0xFFEF7044) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => navProvider.setPageIndex(index),
          child: Padding(
            padding: wide
                ? const EdgeInsets.symmetric(horizontal: 14, vertical: 16)
                : EdgeInsets.zero,
            child: wide
                ? Row(
                    children: [
                      ...children.take(children.length - 1),
                      Expanded(child: children.last),
                    ],
                  )
                : Column(mainAxisSize: MainAxisSize.min, children: children),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required NavigationProvider navProvider,
  }) {
    bool isSelected = navProvider.currentIndex == index;
    final wide = MediaQuery.sizeOf(context).width >= 840;
    Color color = wide
        ? Colors.white
        : (isSelected ? const Color(0xffEF7044) : Colors.grey);

    return _navigationTile(
      index: index,
      navProvider: navProvider,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(isSelected ? activeIcon : icon, color: color, size: 24),
            if (index == 2) // Chat index for regular users
              Consumer<ChatProvider>(
                builder: (context, chatProvider, _) {
                  final unreadCount = chatProvider.totalUnreadCount;
                  if (unreadCount == 0) return const SizedBox.shrink();
                  return Positioned(
                    right: -4,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        unreadCount > 9 ? '9+' : unreadCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 7,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
        SizedBox(height: wide ? 0 : 4, width: wide ? 14 : 0),
        Text(
          label,
          style: GoogleFonts.poppins(
            color: color,
            fontSize: wide ? 14 : 10,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileNavItem({
    required int index,
    required String label,
    required NavigationProvider navProvider,
  }) {
    bool isSelected = navProvider.currentIndex == index;
    final wide = MediaQuery.sizeOf(context).width >= 840;
    Color color = wide
        ? Colors.white
        : (isSelected ? const Color(0xffEF7044) : Colors.grey);

    return _navigationTile(
      index: index,
      navProvider: navProvider,
      children: [
        Consumer<UserProvider>(
          builder: (context, userProvider, _) {
            final image = userProvider.userModel?.user?.image;
            final hasImage = image != null && image.isNotEmpty;
            final imageUrl = hasImage
                ? (image.startsWith('http') ? image : BaseUrl + image)
                : null;

            if (imageUrl != null) {
              return SafeNetworkAvatar(
                imageUrl: imageUrl,
                radius: 13,
                shimmerBase: const Color(0xFF2A2A2A),
                shimmerHighlight: const Color(0xFF3D3D3D),
                errorWidget: Icon(
                  isSelected ? IconlyBold.profile : IconlyLight.profile,
                  color: color,
                  size: 24,
                ),
              );
            }

            return Icon(
              isSelected ? IconlyBold.profile : IconlyLight.profile,
              color: color,
              size: 24,
            );
          },
        ),
        SizedBox(height: wide ? 0 : 4, width: wide ? 14 : 0),
        Text(
          label,
          style: GoogleFonts.poppins(
            color: color,
            fontSize: wide ? 14 : 10,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildHostingNavItem({
    required int index,
    required String label,
    required NavigationProvider navProvider,
  }) {
    bool isSelected = navProvider.currentIndex == index;
    final wide = MediaQuery.sizeOf(context).width >= 840;
    Color color = wide
        ? Colors.white
        : (isSelected ? const Color(0xffEF7044) : Colors.grey);

    return _navigationTile(
      index: index,
      navProvider: navProvider,
      children: [
        Image.asset(
          "images/advertimages/hosting.png",
          width: 24,
          height: 24,
          color: color,
        ),
        SizedBox(height: wide ? 0 : 4, width: wide ? 14 : 0),
        Text(
          label,
          style: GoogleFonts.poppins(
            color: color,
            fontSize: wide ? 14 : 10,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  void _showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => FadeInScale(
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon or Image
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xffEF7044).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    IconlyBold.logout,
                    color: Color(0xffEF7044),
                    size: 40,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Are you sure?",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xff651313),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "Do you want to exit the app?",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "No",
                          style: GoogleFonts.poppins(
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => exit(0),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffEF7044),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "Yes",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FadeInScale extends StatelessWidget {
  final Widget child;
  const FadeInScale({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return FadeIn(
      duration: const Duration(milliseconds: 400),
      child: ZoomIn(duration: const Duration(milliseconds: 400), child: child),
    );
  }
}
