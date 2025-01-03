// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
// / await Firebase.initializeApp(
// /   options: DefaultFirebaseOptions.currentPlatform,
// / );
/// ```
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCF57Y3p7pUkegvLhIBxWcmTNW8FCqNkQE',
    appId: '1:837318256985:web:7f3b1f9bc723002ca44448',
    messagingSenderId: '837318256985',
    projectId: 'food-market-83e98',
    authDomain: 'food-market-83e98.firebaseapp.com',
    storageBucket: 'food-market-83e98.firebasestorage.app',
    measurementId: 'G-HVWRCXWDNC',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA2r8u17X6vpz_PaCW6eSq2KD_0m_GeC0E',
    appId: '1:837318256985:android:959c1b56c264bb3da44448',
    messagingSenderId: '837318256985',
    projectId: 'food-market-83e98',
    storageBucket: 'food-market-83e98.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCLiBahFGaqq9l067ZEjk5Z594q0RnsYX4',
    appId: '1:837318256985:ios:9eac5542481f52f9a44448',
    messagingSenderId: '837318256985',
    projectId: 'food-market-83e98',
    storageBucket: 'food-market-83e98.firebasestorage.app',
    iosBundleId: 'com.example.food',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCLiBahFGaqq9l067ZEjk5Z594q0RnsYX4',
    appId: '1:837318256985:ios:9eac5542481f52f9a44448',
    messagingSenderId: '837318256985',
    projectId: 'food-market-83e98',
    storageBucket: 'food-market-83e98.firebasestorage.app',
    iosBundleId: 'com.example.food',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCF57Y3p7pUkegvLhIBxWcmTNW8FCqNkQE',
    appId: '1:837318256985:web:81d73c6a51136105a44448',
    messagingSenderId: '837318256985',
    projectId: 'food-market-83e98',
    authDomain: 'food-market-83e98.firebaseapp.com',
    storageBucket: 'food-market-83e98.firebasestorage.app',
    measurementId: 'G-VZ589D349L',
  );
}
