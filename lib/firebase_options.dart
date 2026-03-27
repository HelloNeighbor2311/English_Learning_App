import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        return linux;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not configured for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBgLTg9AsBtG6kG3rn5Xb5cuuEs2hnFYQA',
    appId: '1:338474234583:web:3b2ca0b1e0bce084013692',
    messagingSenderId: '338474234583',
    projectId: 'english-app-9c40d',
    storageBucket: 'english-app-9c40d.firebasestorage.app',
    authDomain: 'english-app-9c40d.firebaseapp.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBgLTg9AsBtG6kG3rn5Xb5cuuEs2hnFYQA',
    appId: '1:338474234583:android:3b2ca0b1e0bce084013692',
    messagingSenderId: '338474234583',
    projectId: 'english-app-9c40d',
    storageBucket: 'english-app-9c40d.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBgLTg9AsBtG6kG3rn5Xb5cuuEs2hnFYQA',
    appId: '1:338474234583:ios:3b2ca0b1e0bce084013692',
    messagingSenderId: '338474234583',
    projectId: 'english-app-9c40d',
    storageBucket: 'english-app-9c40d.firebasestorage.app',
    iosBundleId: 'com.example.englishLearningApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBgLTg9AsBtG6kG3rn5Xb5cuuEs2hnFYQA',
    appId: '1:338474234583:ios:3b2ca0b1e0bce084013692',
    messagingSenderId: '338474234583',
    projectId: 'english-app-9c40d',
    storageBucket: 'english-app-9c40d.firebasestorage.app',
    iosBundleId: 'com.example.englishLearningApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBgLTg9AsBtG6kG3rn5Xb5cuuEs2hnFYQA',
    appId: '1:338474234583:web:3b2ca0b1e0bce084013692',
    messagingSenderId: '338474234583',
    projectId: 'english-app-9c40d',
    storageBucket: 'english-app-9c40d.firebasestorage.app',
    authDomain: 'english-app-9c40d.firebaseapp.com',
  );

  static const FirebaseOptions linux = FirebaseOptions(
    apiKey: 'AIzaSyBgLTg9AsBtG6kG3rn5Xb5cuuEs2hnFYQA',
    appId: '1:338474234583:web:3b2ca0b1e0bce084013692',
    messagingSenderId: '338474234583',
    projectId: 'english-app-9c40d',
    storageBucket: 'english-app-9c40d.firebasestorage.app',
    authDomain: 'english-app-9c40d.firebaseapp.com',
  );
}
