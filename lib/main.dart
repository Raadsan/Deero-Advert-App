import 'package:deero_enterprise_app/features/client/Advert%20Features/controllers/news_provider.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/controllers/service_provider.dart';
import 'package:deero_enterprise_app/features/common/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ServiceProvider()),
        ChangeNotifierProvider(create: (_) => NewsProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Deero Enterprice',
        home: SplashPage(),
      ),
    );
  }
}
