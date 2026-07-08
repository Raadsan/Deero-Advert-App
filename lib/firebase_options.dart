import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Firebase configuration for Deero Advert.
///
/// Android values are sourced from [android/app/google-services.json].
/// iOS values match [ios/Runner/GoogleService-Info.plist].
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web.',
      );
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macOS.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA7F0h7msKB1U4cLvqHXLIKhlsfiR-PfGk',
    appId: '1:405966003467:android:37c2e2b7aa3c2c6b71160e',
    messagingSenderId: '405966003467',
    projectId: 'deero-advert',
    storageBucket: 'deero-advert.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA7F0h7msKB1U4cLvqHXLIKhlsfiR-PfGk',
    appId: '1:405966003467:ios:37c2e2b7aa3c2c6b71160e',
    messagingSenderId: '405966003467',
    projectId: 'deero-advert',
    storageBucket: 'deero-advert.firebasestorage.app',
    iosBundleId: 'com.raadsan.deeroadvert',
  );
}
