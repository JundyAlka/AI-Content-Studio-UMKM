import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    if (defaultTargetPlatform == TargetPlatform.android) {
      return android;
    }
    throw UnsupportedError(
      'DefaultFirebaseOptions have not been configured for any platform - '
      'you can reconfigure this by running the FlutterFire CLI again.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyD9bchOiEyGpmb8wn0ov5jNOrRG25zHeJE',
    appId: '1:10847732026:web:471c066c6c23cdad101003',
    messagingSenderId: '10847732026',
    projectId: 'flutter-ai-agent-content',
    authDomain: 'flutter-ai-agent-content.firebaseapp.com',
    storageBucket: 'flutter-ai-agent-content.firebasestorage.app',
    measurementId: 'G-9GKH5TF4YN',
  );

  // Menggunakan konfigurasi Web sementara karena google-services.json tidak ditemukan
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD9bchOiEyGpmb8wn0ov5jNOrRG25zHeJE',
    appId: '1:10847732026:web:471c066c6c23cdad101003',
    messagingSenderId: '10847732026',
    projectId: 'flutter-ai-agent-content',
    storageBucket: 'flutter-ai-agent-content.firebasestorage.app',
  );
}
