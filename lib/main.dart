import 'package:deero_advert_app/features/auth/controllers/user_provider.dart';
import 'package:deero_advert_app/features/client/Advert%20Features/controllers/testimonial_provider.dart';
import 'package:deero_advert_app/features/auth/controllers/register_user_provider.dart';
import 'package:deero_advert_app/features/client/Advert%20Features/controllers/check_domain_provider.dart';
import 'package:deero_advert_app/features/client/Advert%20Features/controllers/hosting_provider.dart';
import 'package:deero_advert_app/features/client/Advert%20Features/controllers/news_provider.dart';
import 'package:deero_advert_app/features/client/Advert%20Features/controllers/portfolio_provider.dart';
import 'package:deero_advert_app/features/client/Advert%20Features/controllers/achievement_provider.dart';
import 'package:deero_advert_app/features/client/Advert%20Features/controllers/service_provider.dart';
import 'package:deero_advert_app/features/client/Advert%20Features/controllers/careers_provider.dart';
import 'package:deero_advert_app/features/client/Advert%20Features/controllers/transaction_provider.dart';
import 'package:deero_advert_app/features/client/Advert%20Features/controllers/navigation_provider.dart';
import 'package:deero_advert_app/features/client/Advert%20Features/controllers/video_provider.dart';
import 'package:deero_advert_app/features/client/Advert%20Features/pages/advert_navigationpage.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:deero_advert_app/features/client/Advert%20Features/controllers/major_client_provider.dart';
import 'package:deero_advert_app/features/client/Advert%20Features/controllers/notification_provider.dart';
import 'package:deero_advert_app/features/client/Advert%20Features/controllers/social_media_provider.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp();
    }
  } catch (e) {
    debugPrint("Firebase already initialized or error: $e");
  }

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await NotificationService.init();
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ServiceProvider()),
        ChangeNotifierProvider(create: (_) => NewsProvider()),
        ChangeNotifierProvider(create: (_) => CareersProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
        ChangeNotifierProvider(create: (_) => HostingProvider()),
        ChangeNotifierProvider(create: (_) => CheckDomainProvider()),
        ChangeNotifierProvider(create: (_) => PortfolioProvider()),
        ChangeNotifierProvider(create: (_) => RegisterUserProvider()),
        ChangeNotifierProvider(
          create: (_) => NotificationProvider(),
          lazy: false,
        ),
        ChangeNotifierProvider(create: (_) => AchievementProvider()),
        ChangeNotifierProvider(create: (_) => MajorClientProvider()),
        ChangeNotifierProvider(create: (_) => VideoProvider()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => SocialMediaProvider()),
        ChangeNotifierProvider(create: (_) => TestimonialProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Deero Advert',
        home: AdvertNavigationpage(),
      ),
    );
  }
}
