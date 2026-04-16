import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError('Web platform is not configured.');
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError('iOS platform is not yet configured.');
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBWQ41thdn6mJceQEYb4jZK_X4XzNe0J2o',
    appId: '1:967234012921:android:d76f0ae1767e7784b1c428',
    messagingSenderId: '967234012921',
    projectId: 'fitness-app-4ac9f',
    storageBucket: 'fitness-app-4ac9f.firebasestorage.app',
  );
}
