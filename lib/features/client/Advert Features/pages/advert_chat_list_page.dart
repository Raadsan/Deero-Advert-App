import 'package:deero_advert_app/core/constant.dart';
import 'package:deero_advert_app/features/auth/pages/login_page.dart';
import 'package:deero_advert_app/features/client/Advert%20Features/controllers/chat_provider.dart';
import 'package:deero_advert_app/features/client/Advert%20Features/pages/advert_chatpage.dart';
import 'package:deero_advert_app/features/client/Advert%20Features/pages/advert_users_list_page.dart';
import 'package:deero_advert_app/features/auth/controllers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class AdvertChatListPage extends StatefulWidget {
  const AdvertChatListPage({super.key});

  @override
  State<AdvertChatListPage> createState() => _AdvertChatListPageState();
}

class _AdvertChatListPageState extends State<AdvertChatListPage> {
  final box = GetStorage();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final chatProvider = Provider.of<ChatProvider>(context, listen: false);

      final userProvider = Provider.of<UserProvider>(context, listen: false);

      // Haddii user login yahay
      if (userProvider.userModel?.user != null) {
        int currentUserId =
            int.tryParse(userProvider.userModel!.user!.id.toString()) ?? -1;

        chatProvider.connectSocket(currentUserId);
        chatProvider.fetchConversations();
      }
    });
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      return DateFormat('HH:mm').format(dateTime);
    } else if (difference.inDays < 7) {
      return DateFormat('E').format(dateTime);
    } else {
      return DateFormat('MMM d').format(dateTime);
    }
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      itemCount: 8,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            child: Row(
              children: [
                const CircleAvatar(radius: 26, backgroundColor: Colors.white),

                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(width: 150, height: 16, color: Colors.white),

                      const SizedBox(height: 8),

                      Container(
                        width: double.infinity,
                        height: 12,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    final isLoggedIn = userProvider.userModel?.user != null;

    // USER AAN LOGIN AHEYN
    if (!isLoggedIn) {
      return Scaffold(
        backgroundColor: Colors.white,

        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,

          title: Text(
            "Messages",
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                Container(
                  padding: const EdgeInsets.all(24),

                  decoration: BoxDecoration(
                    color: const Color(0xff651210).withOpacity(0.1),

                    shape: BoxShape.circle,
                  ),

                  child: const Icon(
                    IconlyLight.chat,
                    size: 65,
                    color: Color(0xff651210),
                  ),
                ),

                const SizedBox(height: 24),

                Text(
                  "Login or Register",
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  "Please login or create a new account to start conversations, send messages, and connect with other users.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    height: 1.6,
                  ),
                ),

                const SizedBox(height: 30),

                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    height: 55,
                  
                    decoration: BoxDecoration(
                      color: const Color(0xff651210),
                      borderRadius: BorderRadius.circular(14),
                    ),
                  
                    child: Center(
                      child: Text(
                        "Login / Register",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        title: Text(
          "Messages",
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [
          IconButton(
            icon: const Icon(IconlyLight.search, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),

      body: Consumer<ChatProvider>(
        builder: (context, chatProvider, child) {
          if (chatProvider.isLoading && chatProvider.conversations.isEmpty) {
            return _buildShimmerLoading();
          }

          if (chatProvider.conversations.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Container(
                    padding: const EdgeInsets.all(24),

                    decoration: BoxDecoration(
                      color: const Color(0xffEF7044).withOpacity(0.1),

                      shape: BoxShape.circle,
                    ),

                    child: const Icon(
                      IconlyLight.chat,
                      size: 60,
                      color: Color(0xffEF7044),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    "No conversations yet",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "Tap the button below to start chatting",
                    style: GoogleFonts.poppins(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            );
          }

          final sortedConversations = List.from(chatProvider.conversations)
            ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),

            itemCount: sortedConversations.length,

            itemBuilder: (context, index) {
              final conv = sortedConversations[index];

              int currentUserId =
                  int.tryParse(userProvider.userModel!.user!.id.toString()) ??
                  -1;

              final isUser1 = conv.participant1Id == currentUserId;

              final otherUser = isUser1 ? conv.participant2 : conv.participant1;

              final otherName = otherUser?['fullname'] ?? "Unknown User";

              final otherImage = otherUser?['image'];

              return InkWell(
                onTap: () {
                  Provider.of<ChatProvider>(
                    context,
                    listen: false,
                  ).markAsRead(conv.id, currentUserId);

                  box.write('last_chat_user', {
                    'name': otherName,
                    'image': otherImage,
                    'convId': conv.id,
                    'timestamp': DateTime.now().toIso8601String(),
                  });

                  Navigator.push(
                    context,

                    MaterialPageRoute(
                      builder: (context) =>
                          AdvertChatConversationPage(conversation: conv),
                    ),
                  );
                },

                borderRadius: BorderRadius.circular(12),

                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 8,
                  ),

                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 26,

                        backgroundColor: const Color(
                          0xffEF7044,
                        ).withOpacity(0.2),

                        backgroundImage:
                            otherImage != null &&
                                otherImage.toString().isNotEmpty
                            ? NetworkImage(
                                otherImage.toString().startsWith('http')
                                    ? otherImage.toString()
                                    : BaseUrl + otherImage.toString(),
                              )
                            : null,

                        child:
                            otherImage == null || otherImage.toString().isEmpty
                            ? Text(
                                otherName.isNotEmpty
                                    ? otherName[0].toUpperCase()
                                    : '?',

                                style: GoogleFonts.poppins(
                                  color: const Color(0xffEF7044),

                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : null,
                      ),

                      const SizedBox(width: 16),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,

                              children: [
                                Expanded(
                                  child: Text(
                                    otherName,

                                    style: GoogleFonts.poppins(
                                      fontSize: 16,

                                      fontWeight: conv.unreadCount > 0
                                          ? FontWeight.bold
                                          : FontWeight.w600,

                                      color: Colors.black87,
                                    ),

                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),

                                Text(
                                  _formatDateTime(conv.updatedAt),

                                  style: GoogleFonts.poppins(
                                    fontSize: 11,

                                    color: conv.unreadCount > 0
                                        ? const Color(0xffEF7044)
                                        : Colors.grey,

                                    fontWeight: conv.unreadCount > 0
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 4),

                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    conv.lastMessage ??
                                        "Started a conversation",

                                    style: GoogleFonts.poppins(
                                      fontSize: 13,

                                      color: conv.unreadCount > 0
                                          ? Colors.black87
                                          : Colors.grey.shade600,

                                      fontWeight: conv.unreadCount > 0
                                          ? FontWeight.w500
                                          : FontWeight.normal,
                                    ),

                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),

                                if (conv.unreadCount > 0)
                                  Container(
                                    padding: const EdgeInsets.all(6),

                                    decoration: const BoxDecoration(
                                      color: Color(0xffEF7044),

                                      shape: BoxShape.circle,
                                    ),

                                    child: Text(
                                      conv.unreadCount.toString(),

                                      style: const TextStyle(
                                        color: Colors.white,

                                        fontSize: 10,

                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xffEF7044),

        onPressed: () {
          Navigator.push(
            context,

            MaterialPageRoute(
              builder: (context) => const AdvertUsersListPage(),
            ),
          );
        },

        child: const Icon(IconlyLight.edit_square, color: Colors.white),
      ),
    );
  }
}
