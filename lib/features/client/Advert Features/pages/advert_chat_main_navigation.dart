import 'package:deero_advert_app/features/client/Advert Features/pages/advert_chat_list_page.dart';
import 'package:deero_advert_app/features/client/Advert Features/pages/advert_profilepage.dart';
import 'package:deero_advert_app/features/client/Advert Features/controllers/chat_provider.dart';
import 'package:deero_advert_app/features/auth/controllers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

class AdvertChatMainNavigation extends StatefulWidget {
  const AdvertChatMainNavigation({super.key});

  @override
  State<AdvertChatMainNavigation> createState() => _AdvertChatMainNavigationState();
}

class _AdvertChatMainNavigationState extends State<AdvertChatMainNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const AdvertChatListPage(),
    const AdvertProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final chatProvider = Provider.of<ChatProvider>(context, listen: false);
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      
      if (userProvider.userModel?.user != null) {
        int currentUserId = int.tryParse(userProvider.userModel!.user!.id.toString()) ?? -1;
        chatProvider.connectSocket(currentUserId);
        chatProvider.fetchConversations();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  index: 0,
                  icon: IconlyLight.chat,
                  activeIcon: IconlyBold.chat,
                  label: 'Chat',
                ),
                _buildNavItem(
                  index: 1,
                  icon: IconlyLight.profile,
                  activeIcon: IconlyBold.profile,
                  label: 'Profile',
                ),
              ],
            ),
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
  }) {
    bool isSelected = _selectedIndex == index;
    Color color = isSelected ? const Color(0xffEF7044) : Colors.grey;

    return InkWell(
      onTap: () => setState(() => _selectedIndex = index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(isSelected ? activeIcon : icon, color: color, size: 26),
              if (index == 0) // Chat icon
                Consumer<ChatProvider>(
                  builder: (context, chatProvider, _) {
                    final unreadCount = chatProvider.totalUnreadCount;
                    if (unreadCount == 0) return const SizedBox.shrink();
                    return Positioned(
                      right: -2,
                      top: -2,
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
                            fontSize: 8,
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
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.poppins(
              color: color,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
