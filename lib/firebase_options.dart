// File generated with Firebase configuration for noteapp-1e550
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.iOS:
        return ios;
      default:
        return web;
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyB2_fDEFELS6LQsUEsiPVVfcPH4fl2XJ_g',
    appId: '1:109584181612:web:934fa5138b41b425d46b49',
    messagingSenderId: '109584181612',
    projectId: 'noteapp-1e550',
    authDomain: 'noteapp-1e550.firebaseapp.com',
    storageBucket: 'noteapp-1e550.firebasestorage.app',
    measurementId: 'G-FTQVM7LGKN',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyB2_fDEFELS6LQsUEsiPVVfcPH4fl2XJ_g',
    appId: '1:109584181612:web:934fa5138b41b425d46b49',
    messagingSenderId: '109584181612',
    projectId: 'noteapp-1e550',
    authDomain: 'noteapp-1e550.firebaseapp.com',
    storageBucket: 'noteapp-1e550.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB2_fDEFELS6LQsUEsiPVVfcPH4fl2XJ_g',
    appId: '1:109584181612:web:934fa5138b41b425d46b49',
    messagingSenderId: '109584181612',
    projectId: 'noteapp-1e550',
    storageBucket: 'noteapp-1e550.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB2_fDEFELS6LQsUEsiPVVfcPH4fl2XJ_g',
    appId: '1:109584181612:web:934fa5138b41b425d46b49',
    messagingSenderId: '109584181612',
    projectId: 'noteapp-1e550',
    storageBucket: 'noteapp-1e550.firebasestorage.app',
  );
}
