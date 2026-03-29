import 'package:deero_enterprise_app/features/client/Advert%20Features/controllers/notification_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdvertNotificationpage extends StatefulWidget {
  const AdvertNotificationpage({super.key});

  @override
  State<AdvertNotificationpage> createState() => _AdvertNotificationpageState();
}

class _AdvertNotificationpageState extends State<AdvertNotificationpage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<NotificationProvider>();
      provider.getAllNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notifications"), centerTitle: true),
      body: Consumer<NotificationProvider>(
        builder: (context, notificationProvider, _) {
          final notificationList =
              notificationProvider.notificationModel?.data ?? [];

          if (notificationProvider.isLoading && notificationList.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (notificationProvider.error != null && notificationList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Error: ${notificationProvider.error}"),
                  ElevatedButton(
                    onPressed: () => notificationProvider.getAllNotifications(),
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          }

          if (notificationList.isEmpty) {
            return RefreshIndicator(
              onRefresh: () => notificationProvider.getAllNotifications(),
              child: ListView(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.4),
                  const Center(child: Text("No notifications found.")),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => notificationProvider.getAllNotifications(),
            child: ListView.separated(
              separatorBuilder: (context, index) => const Divider(),
              itemCount: notificationList.length,
              itemBuilder: (context, index) {
                final notification = notificationList[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xff660E0D),
                    child: Icon(Icons.notifications, color: Colors.white),
                  ),
                  title: Text(
                    notification.title ?? "No title",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(notification.message ?? "No message"),
                      Text("End Date: ${notification.endDate}"),
                    ],
                  ),
                  onTap: () {
                    // Navigate to details if needed
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
