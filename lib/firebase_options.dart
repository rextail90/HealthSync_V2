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
    apiKey: 'AIzaSyC4M5oUJZLbBF4DcQ6u9CkMI6p2fnEv7l0',
    appId: '1:703778128417:web:24140a6930feb453e91960',
    messagingSenderId: '703778128417',
    projectId: 'healthsync-cda1a',
    authDomain: 'healthsync-cda1a.firebaseapp.com',
    databaseURL: 'https://healthsync-cda1a-default-rtdb.firebaseio.com',
    storageBucket: 'healthsync-cda1a.appspot.com',
    measurementId: 'G-JDJK0J2P20',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBC0dHoyQGP5qfOkxFSpBgX5OizgO4GrTc',
    appId: '1:703778128417:android:e7c90ca73cd9afa6e91960',
    messagingSenderId: '703778128417',
    projectId: 'healthsync-cda1a',
    databaseURL: 'https://healthsync-cda1a-default-rtdb.firebaseio.com',
    storageBucket: 'healthsync-cda1a.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCNi6--uh6F28h_LQy8svx6ONUH7YAVrBQ',
    appId: '1:703778128417:ios:d0de663ffda2fef9e91960',
    messagingSenderId: '703778128417',
    projectId: 'healthsync-cda1a',
    databaseURL: 'https://healthsync-cda1a-default-rtdb.firebaseio.com',
    storageBucket: 'healthsync-cda1a.appspot.com',
    iosBundleId: 'com.example.healthsyncMaybe',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCNi6--uh6F28h_LQy8svx6ONUH7YAVrBQ',
    appId: '1:703778128417:ios:d0de663ffda2fef9e91960',
    messagingSenderId: '703778128417',
    projectId: 'healthsync-cda1a',
    databaseURL: 'https://healthsync-cda1a-default-rtdb.firebaseio.com',
    storageBucket: 'healthsync-cda1a.appspot.com',
    iosBundleId: 'com.example.healthsyncMaybe',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyC4M5oUJZLbBF4DcQ6u9CkMI6p2fnEv7l0',
    appId: '1:703778128417:web:c3123ffb30b0195ee91960',
    messagingSenderId: '703778128417',
    projectId: 'healthsync-cda1a',
    authDomain: 'healthsync-cda1a.firebaseapp.com',
    databaseURL: 'https://healthsync-cda1a-default-rtdb.firebaseio.com',
    storageBucket: 'healthsync-cda1a.appspot.com',
    measurementId: 'G-KD9X7TXFW6',
  );
}
