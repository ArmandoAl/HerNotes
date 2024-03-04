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
    apiKey: 'AIzaSyCMUuBPGZxcJmCq8zfk7ppSxv3wfm4I3t0',
    appId: '1:137455453893:web:85912e63e28413f227d2ac',
    messagingSenderId: '137455453893',
    projectId: 'hernotes',
    authDomain: 'hernotes.firebaseapp.com',
    storageBucket: 'hernotes.appspot.com',
    measurementId: 'G-CCTYNZ8NGK',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBb39gXj1FCJn4TU7U8LLu9QIyCuuKrp8Y',
    appId: '1:137455453893:android:7b79fee7e6f877b027d2ac',
    messagingSenderId: '137455453893',
    projectId: 'hernotes',
    storageBucket: 'hernotes.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBkSDkMAHpJus015_mjTaVqQgr447odbmI',
    appId: '1:137455453893:ios:bf7a7929d182e7cb27d2ac',
    messagingSenderId: '137455453893',
    projectId: 'hernotes',
    storageBucket: 'hernotes.appspot.com',
    iosBundleId: 'com.example.her_notes',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBkSDkMAHpJus015_mjTaVqQgr447odbmI',
    appId: '1:137455453893:ios:765021ba0356d5f227d2ac',
    messagingSenderId: '137455453893',
    projectId: 'hernotes',
    storageBucket: 'hernotes.appspot.com',
    iosBundleId: 'com.example.her_notes.RunnerTests',
  );
}
