import 'package:deero_enterprise_app/features/auth/controllers/user_provider.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/controllers/check_domain_provider.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/controllers/hosting_provider.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/controllers/news_provider.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/controllers/portfolio_provider.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/controllers/service_provider.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/controllers/careers_provider.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/controllers/transaction_provider.dart';
import 'package:deero_enterprise_app/features/client/Enterprise%20Features/controllers/notification_provider.dart';
import 'package:deero_enterprise_app/features/common/splash_page.dart';
import 'package:deero_enterprise_app/features/navigation/advert_navigationpage.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyB6ZJZJZJZJZJZJZJZJZJZJZJZJZJZJZJ",
      appId: "1:1234567890:android:12345678901234567890",
      messagingSenderId: "12345678901234567890",
      projectId: "deeroenterpriceapp",
    ),
  );
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
        ChangeNotifierProvider(
          create: (_) => NotificationProvider(),
          lazy: false,
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Deero Enterprice',
        home: AdvertNavigationpage(),
      ),
    );
  }
}
