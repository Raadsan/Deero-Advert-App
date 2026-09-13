import 'package:deero_advert_app/core/app_error_handler.dart';
import 'package:deero_advert_app/core/constant.dart';
import 'package:deero_advert_app/core/widgets/safe_network_image.dart';
import 'package:deero_advert_app/features/auth/pages/login_page.dart';
import 'package:deero_advert_app/features/client/Advert%20Features/controllers/chat_provider.dart';
import 'package:deero_advert_app/features/client/Advert%20Features/pages/advert_chatpage.dart';
import 'package:deero_advert_app/features/client/Advert%20Features/pages/advert_users_list_page.dart';
import 'package:deero_advert_app/features/client/Advert%20Features/models/chat_model.dart';
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

        final currentUserRole =
            userProvider.userModel?.user?.role?.name?.toLowerCase() ?? 'user';
        if (currentUserRole == 'user') {
          chatProvider.fetchCustomerCareUsers();
        }
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

  Conversation? _findConversationWithUser(
    List<Conversation> conversations,
    int userId,
    int currentUserId,
  ) {
    for (final conv in conversations) {
      final otherId = conv.participant1Id == currentUserId
          ? conv.participant2Id
          : conv.participant1Id;
      if (otherId == userId) return conv;
    }
    return null;
  }

  Future<void> _openConversation(Conversation conversation) async {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    final currentUserId =
        int.tryParse(
          Provider.of<UserProvider>(context, listen: false)
                  .userModel
                  ?.user
                  ?.id
                  .toString() ??
              '',
        ) ??
        -1;
    final isUser1 = conversation.participant1Id == currentUserId;
    final otherUser =
        isUser1 ? conversation.participant2 : conversation.participant1;
    final otherName = otherUser?['fullname'] ?? "Unknown User";
    final otherImage = otherUser?['image'];

    chatProvider.markAsRead(conversation.id, currentUserId);
    box.write('last_chat_user', {
      'name': otherName,
      'image': otherImage,
      'convId': conversation.id,
      'timestamp': DateTime.now().toIso8601String(),
    });

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            AdvertChatConversationPage(conversation: conversation),
      ),
    );

    if (mounted) {
      chatProvider.fetchConversations();
    }
  }

  Future<void> _startChatWithAgent(int participantId) async {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    final currentUserId =
        int.tryParse(
          Provider.of<UserProvider>(context, listen: false)
                  .userModel
                  ?.user
                  ?.id
                  .toString() ??
              '',
        ) ??
        -1;

    final existing = _findConversationWithUser(
      chatProvider.conversations,
      participantId,
      currentUserId,
    );

    if (existing != null) {
      await _openConversation(existing);
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(color: Color(0xffEF7044)),
      ),
    );

    try {
      final conversation = await chatProvider.createOrGetConversation(
        participantId,
      );

      if (!mounted) return;
      Navigator.pop(context);

      if (conversation != null) {
        await _openConversation(conversation);
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppErrorHandler.toFriendlyMessage(e))),
      );
    }
  }

  Widget _buildCustomerCareTile(Map<String, dynamic> user) {
    final name = user['fullname']?.toString() ?? 'Customer Care';
    final image = user['image']?.toString();
    final userId = int.tryParse(
          user['_id']?.toString() ?? user['id']?.toString() ?? '',
        ) ??
        -1;

    return InkWell(
      onTap: userId == -1 ? null : () => _startChatWithAgent(userId),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        decoration: BoxDecoration(
          color: const Color(0xffEF7044).withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xffEF7044).withOpacity(0.2),
          ),
        ),
        child: Row(
          children: [
            SafeNetworkAvatar(
              imageUrl: image != null && image.isNotEmpty
                  ? (image.startsWith('http') ? image : BaseUrl + image)
                  : null,
              radius: 26,
              shimmerBase: const Color(0xFFFFE4D8),
              shimmerHighlight: const Color(0xFFFFF0EB),
              errorWidget: CircleAvatar(
                radius: 26,
                backgroundColor: const Color(0xffEF7044).withValues(alpha: 0.15),
                child: Text(
                  name.isNotEmpty ? name[0].toUpperCase() : 'C',
                  style: GoogleFonts.poppins(
                    color: const Color(0xffEF7044),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Customer Care • Tap to chat",
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: const Color(0xffEF7044),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              IconlyLight.chat,
              color: Color(0xffEF7044),
              size: 22,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConversationTile({
    required dynamic conv,
    required int currentUserId,
  }) {
    final isUser1 = conv.participant1Id == currentUserId;
    final otherUser = isUser1 ? conv.participant2 : conv.participant1;
    final otherName = otherUser?['fullname'] ?? "Unknown User";
    final otherImage = otherUser?['image'];

    return InkWell(
      onTap: () => _openConversation(conv as Conversation),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 8,
        ),
        child: Row(
          children: [
            SafeNetworkAvatar(
              imageUrl: otherImage != null &&
                      otherImage.toString().isNotEmpty
                  ? (otherImage.toString().startsWith('http')
                      ? otherImage.toString()
                      : BaseUrl + otherImage.toString())
                  : null,
              radius: 26,
              shimmerBase: const Color(0xFFFFE4D8),
              shimmerHighlight: const Color(0xFFFFF0EB),
              errorWidget: CircleAvatar(
                radius: 26,
                backgroundColor: const Color(0xffEF7044).withValues(alpha: 0.2),
                child: Text(
                  otherName.isNotEmpty ? otherName[0].toUpperCase() : '?',
                  style: GoogleFonts.poppins(
                    color: const Color(0xffEF7044),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
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
                          conv.lastMessage ?? "Started a conversation",
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

    final currentUserRole =
        userProvider.userModel?.user?.role?.name?.toLowerCase() ?? 'user';
    final isRegularUser = currentUserRole == 'user';
    final currentUserId =
        int.tryParse(userProvider.userModel!.user!.id.toString()) ?? -1;

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
          final sortedConversations = List<Conversation>.from(
            chatProvider.conversations,
          )..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

          if (isRegularUser) {
            final customerCareUsers = chatProvider.customerCareUsers
                .where((user) {
                  final userId = int.tryParse(
                        user['_id']?.toString() ??
                            user['id']?.toString() ??
                            '',
                      ) ??
                      -2;
                  return userId != currentUserId;
                })
                .map((user) => Map<String, dynamic>.from(user as Map))
                .toList();

            final availableAgents = customerCareUsers.where((user) {
              final userId = int.tryParse(
                    user['_id']?.toString() ?? user['id']?.toString() ?? '',
                  ) ??
                  -1;
              return _findConversationWithUser(
                    sortedConversations,
                    userId,
                    currentUserId,
                  ) ==
                  null;
            }).toList();

            final isInitialLoading = chatProvider.isLoading &&
                sortedConversations.isEmpty &&
                customerCareUsers.isEmpty;

            if (isInitialLoading) {
              return _buildShimmerLoading();
            }

            if (sortedConversations.isEmpty && availableAgents.isEmpty) {
              return Center(
                child: Text(
                  "Customer Care is not available right now.",
                  style: GoogleFonts.poppins(color: Colors.grey),
                ),
              );
            }

            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              children: [
                if (sortedConversations.isNotEmpty) ...[
                  ...sortedConversations.map(
                    (conv) => _buildConversationTile(
                      conv: conv,
                      currentUserId: currentUserId,
                    ),
                  ),
                ],
                if (availableAgents.isNotEmpty) ...[
                  if (sortedConversations.isNotEmpty) const SizedBox(height: 16),
                  Text(
                    "Customer Care",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (chatProvider.isLoading && customerCareUsers.isEmpty)
                    ...List.generate(
                      2,
                      (_) => Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          height: 72,
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    )
                  else
                    ...availableAgents.map(_buildCustomerCareTile),
                ],
              ],
            );
          }

          if (chatProvider.isLoading && sortedConversations.isEmpty) {
            return _buildShimmerLoading();
          }

          if (sortedConversations.isEmpty) {
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
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            itemCount: sortedConversations.length,
            itemBuilder: (context, index) {
              return _buildConversationTile(
                conv: sortedConversations[index],
                currentUserId: currentUserId,
              );
            },
          );
        },
      ),

      floatingActionButton: isRegularUser
          ? null
          : FloatingActionButton(
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
