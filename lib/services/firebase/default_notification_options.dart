import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {

  static FirebaseOptions? get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return _android;
      case TargetPlatform.iOS:
        return null;
      case TargetPlatform.macOS:
        return null;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
              'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
              'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

   static FirebaseOptions get _android {
    return const FirebaseOptions(
      apiKey: 'AIzaSyA1C5oCjXFfe4__kreZkfwI3ch9PlB5PwI',
      appId: '1:812941224886:android:c8af46dc8b106bc6072f17',
      messagingSenderId: '812941224886',
      projectId: 'igl-cng',
      storageBucket: 'igl-cng.appspot.com',
    );
  }

}