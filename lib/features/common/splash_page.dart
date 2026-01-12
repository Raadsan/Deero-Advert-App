import 'package:deero_enterprise_app/features/client/Enterprise%20Features/pages/enterprise_homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_splash/flutter_animated_splash.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplash(
      type: Transition.size,
      child: Image.asset('images/enterpriseLogo.png', width: 200, height: 200),
      curve: Curves.easeInOut,
      navigator:  EnterpriseHomepage(),
      durationInSeconds: 1,
    );
  }
}
