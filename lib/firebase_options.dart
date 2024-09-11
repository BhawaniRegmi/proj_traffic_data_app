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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyAQV_NGgHG1M1SKN-Gi1WvizlfOFgVTsGk',
    appId: '1:469761837875:web:28ea236cac96b4ccaf0c46',
    messagingSenderId: '469761837875',
    projectId: 'flutter-traffic-project',
    authDomain: 'flutter-traffic-project.firebaseapp.com',
    storageBucket: 'flutter-traffic-project.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC3DhUgVdY-uQfIlZbFZhXFaUY5bJ0rCvU',
    appId: '1:469761837875:android:e32812f86de78e58af0c46',
    messagingSenderId: '469761837875',
    projectId: 'flutter-traffic-project',
    storageBucket: 'flutter-traffic-project.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDk4I_JbtgdLBvDtRA90eMCYdUaIh-q_b0',
    appId: '1:469761837875:ios:02c7495bf9996f29af0c46',
    messagingSenderId: '469761837875',
    projectId: 'flutter-traffic-project',
    storageBucket: 'flutter-traffic-project.appspot.com',
    iosBundleId: 'com.example.trafficDataApp',
  );

}