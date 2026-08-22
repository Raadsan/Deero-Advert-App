import 'package:deero_advert_app/core/constant.dart';
import 'package:deero_advert_app/features/client/Advert%20Features/controllers/chat_provider.dart';
import 'package:deero_advert_app/features/client/Advert%20Features/pages/advert_chatpage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:deero_advert_app/features/auth/controllers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class AdvertUsersListPage extends StatefulWidget {
  const AdvertUsersListPage({super.key});

  @override
  State<AdvertUsersListPage> createState() => _AdvertUsersListPageState();
}

class _AdvertUsersListPageState extends State<AdvertUsersListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final chatProvider = Provider.of<ChatProvider>(context, listen: false);
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final currentUserRole =
          userProvider.userModel?.user?.role?.name?.toLowerCase() ?? 'user';

      if (currentUserRole == 'user') {
        chatProvider.fetchCustomerCareUsers();
      } else {
        chatProvider.fetchAllUsers();
      }
    });
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                const CircleAvatar(radius: 24, backgroundColor: Colors.white),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(width: 140, height: 16, color: Colors.white),
                      const SizedBox(height: 8),
                      Container(width: 180, height: 12, color: Colors.white),
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

  void _startChat(int participantId) async {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    // Show loading indicator
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

      // Hide loading
      Navigator.pop(context);

      if (conversation != null && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                AdvertChatConversationPage(conversation: conversation),
          ),
        );
      }
    } catch (e) {
      // Hide loading
      Navigator.pop(context);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final currentUserRole =
        userProvider.userModel?.user?.role?.name?.toLowerCase() ?? 'user';
    final isRegularUser = currentUserRole == 'user';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(IconlyLight.arrow_left_2, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          isRegularUser ? "Customer Care" : "Select Contact",
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Consumer<ChatProvider>(
        builder: (context, chatProvider, child) {
          final userProvider = Provider.of<UserProvider>(
            context,
            listen: false,
          );
          final currentUserId =
              int.tryParse(userProvider.userModel?.user?.id.toString() ?? '') ??
              -1;
          final currentUserRole =
              userProvider.userModel?.user?.role?.name?.toLowerCase() ?? 'user';
          final isRegularUser = currentUserRole == 'user';
          final sourceUsers = isRegularUser
              ? chatProvider.customerCareUsers
              : chatProvider.allUsers;

          if (chatProvider.isLoading && sourceUsers.isEmpty) {
            return _buildShimmerLoading();
          }

          final filteredUsers = isRegularUser
              ? sourceUsers.where((u) {
                  final userId = int.tryParse(
                        u['_id']?.toString() ?? u['id']?.toString() ?? '',
                      ) ??
                      -2;
                  return userId != currentUserId;
                }).toList()
              : sourceUsers.where((u) {
            final userId =
                int.tryParse(
                  u['_id']?.toString() ?? u['id']?.toString() ?? '',
                ) ??
                -2;

            // Get role name safely
            String? roleName;
            if (u['role'] != null) {
              roleName = u['role']['name']?.toString().toLowerCase();
            }

            // 1. Always exclude self
            if (userId == currentUserId) return false;

            // 2. Logic for "user" role: Only see people who are "Customer Care"
            if (currentUserRole == 'user') {
              return roleName == 'customer care';
            }

            // 3. Logic for "admin" role: See everyone
            if (currentUserRole == 'admin') {
              return true;
            }

            // Default: show everyone else
            return true;
          }).toList();

          if (filteredUsers.isEmpty) {
            return Center(
              child: Text(
                isRegularUser
                    ? "Customer Care is not available right now."
                    : "No other users found.",
                style: GoogleFonts.poppins(color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filteredUsers.length,
            itemBuilder: (context, index) {
              final user = filteredUsers[index];
              return InkWell(
                onTap: () => _startChat(
                  int.parse(user['_id']?.toString() ?? user['id'].toString()),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade100),
                    ),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: const Color(
                          0xffEF7044,
                        ).withOpacity(0.1),
                        backgroundImage:
                            user['image'] != null &&
                                user['image'].toString().isNotEmpty
                            ? NetworkImage(
                                user['image'].toString().startsWith('http')
                                    ? user['image'].toString()
                                    : BaseUrl + user['image'].toString(),
                              )
                            : null,
                        child:
                            user['image'] == null ||
                                user['image'].toString().isEmpty
                            ? Text(
                                user['fullname'] != null &&
                                        user['fullname'].toString().isNotEmpty
                                    ? user['fullname'][0].toUpperCase()
                                    : '?',
                                style: GoogleFonts.poppins(
                                  color: const Color(0xffEF7044),
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
                              children: [
                                Text(
                                  user['fullname'] ?? 'Unknown User',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                                if (user['role'] != null) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(
                                        0xffEF7044,
                                      ).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      user['role']['name'] ?? '',
                                      style: GoogleFonts.poppins(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xffEF7044),
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              user['email'] ?? '',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: Colors.grey,
                              ),
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
    );
  }
}
