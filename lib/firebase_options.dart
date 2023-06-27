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
    apiKey: 'AIzaSyA92dyleZsFrBDsuBvoniTbE5OPMSE_jCU',
    appId: '1:146898288818:web:62710f9ae1ef6dc9b589ab',
    messagingSenderId: '146898288818',
    projectId: 'herstartproyectv1',
    authDomain: 'herstartproyectv1.firebaseapp.com',
    storageBucket: 'herstartproyectv1.appspot.com',
    measurementId: 'G-5TNDZ7QDE0',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDzqCZ4GZG5zkGOL-m6s-2wjrTmjd2FYTs',
    appId: '1:146898288818:android:095bda6d64395b08b589ab',
    messagingSenderId: '146898288818',
    projectId: 'herstartproyectv1',
    storageBucket: 'herstartproyectv1.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA2JAAce6js4xtwdwgGod5wBxdGo6Xx274',
    appId: '1:146898288818:ios:51a6ac9ff2d64064b589ab',
    messagingSenderId: '146898288818',
    projectId: 'herstartproyectv1',
    storageBucket: 'herstartproyectv1.appspot.com',
    iosClientId: '146898288818-2v13gbak3o4k9t5ctbnu840kja5rb3i8.apps.googleusercontent.com',
    iosBundleId: 'com.example.first',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA2JAAce6js4xtwdwgGod5wBxdGo6Xx274',
    appId: '1:146898288818:ios:ce7069a40c67395eb589ab',
    messagingSenderId: '146898288818',
    projectId: 'herstartproyectv1',
    storageBucket: 'herstartproyectv1.appspot.com',
    iosClientId: '146898288818-7ic8cfla38rh5deola54e514vr88oi4c.apps.googleusercontent.com',
    iosBundleId: 'com.example.first.RunnerTests',
  );
}
