// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDD8gExrJmXwaFetRpfY8-c71HMbwy8vRw',
    appId: '1:318771620552:web:baf6fa348e12547af093fd',
    messagingSenderId: '318771620552',
    projectId: 'laplace-c64fb',
    authDomain: 'laplace-c64fb.firebaseapp.com',
    storageBucket: 'laplace-c64fb.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDbEcc-pv49PXaQ72Ys8gMkAKw76wxbJL4',
    appId: '1:318771620552:android:60a1707a7cc49ef8f093fd',
    messagingSenderId: '318771620552',
    projectId: 'laplace-c64fb',
    storageBucket: 'laplace-c64fb.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCj-XdqC5pzCAqstvPyU9eMWE0DE6-NGM0',
    appId: '1:318771620552:ios:ca9d6a2727a07ef2f093fd',
    messagingSenderId: '318771620552',
    projectId: 'laplace-c64fb',
    storageBucket: 'laplace-c64fb.firebasestorage.app',
    iosBundleId: 'com.example.laplace',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCj-XdqC5pzCAqstvPyU9eMWE0DE6-NGM0',
    appId: '1:318771620552:ios:613365b29976c0f7f093fd',
    messagingSenderId: '318771620552',
    projectId: 'laplace-c64fb',
    storageBucket: 'laplace-c64fb.firebasestorage.app',
    iosBundleId: 'com.example.laplace.RunnerTests',
  );
}
