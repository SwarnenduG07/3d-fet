import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static bool get _hasIosConfig =>
      ios.apiKey.isNotEmpty &&
      ios.appId.isNotEmpty &&
      ios.iosBundleId?.isNotEmpty == true;

  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError('Web platform is not configured.');
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        if (!_hasIosConfig) {
          throw UnsupportedError(
            'iOS Firebase is not configured. Add iOS app values to '
            'lib/firebase_options.dart (or via --dart-define) and add '
            'ios/Runner/GoogleService-Info.plist.',
          );
        }
        return ios;
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

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAxqSOpeG2Dq5JWHFIYse-DKKHDrVxHjno',
    appId: '1:967234012921:ios:4f72570329567aedb1c428',
    messagingSenderId: '967234012921',
    projectId: 'fitness-app-4ac9f',
    storageBucket: 'fitness-app-4ac9f.firebasestorage.app',
    iosBundleId: 'com.example.games',
    iosClientId:
        '967234012921-bckp4vu9rhe7t8q6gapc2itn722vpbv4.apps.googleusercontent.com',
  );
}
