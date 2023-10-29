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
    apiKey: 'AIzaSyBGNqaVZ7f33gO7uP8EWzuL6bvRiX2i1pY',
    appId: '1:13592340490:web:058e92f42fdc27a25997f3',
    messagingSenderId: '13592340490',
    projectId: 'net-chat-firebase',
    authDomain: 'net-chat-firebase.firebaseapp.com',
    storageBucket: 'net-chat-firebase.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA7dPsdbNtyI6m4bOzp2T_-GZQg6xoO2fc',
    appId: '1:13592340490:android:dee6a78b4e70328e5997f3',
    messagingSenderId: '13592340490',
    projectId: 'net-chat-firebase',
    storageBucket: 'net-chat-firebase.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCfdkrXzwp-0RlQWUD6ppOSK0DCyUTnCmA',
    appId: '1:13592340490:ios:7cfc456ced1a79165997f3',
    messagingSenderId: '13592340490',
    projectId: 'net-chat-firebase',
    storageBucket: 'net-chat-firebase.appspot.com',
    iosBundleId: 'com.example.netChatFirebase',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCfdkrXzwp-0RlQWUD6ppOSK0DCyUTnCmA',
    appId: '1:13592340490:ios:725845fd8340753b5997f3',
    messagingSenderId: '13592340490',
    projectId: 'net-chat-firebase',
    storageBucket: 'net-chat-firebase.appspot.com',
    iosBundleId: 'com.example.netChatFirebase.RunnerTests',
  );
}