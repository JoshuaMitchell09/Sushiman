import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyBmCFFC6A-Nwc-vNFSQez4FpJ1hf-0xrio",
            authDomain: "iiic2026lunes-2da9d.firebaseapp.com",
            projectId: "iiic2026lunes-2da9d",
            storageBucket: "iiic2026lunes-2da9d.firebasestorage.app",
            messagingSenderId: "398985903968",
            appId: "1:398985903968:web:7a6f4e0bfd33fe4f222805",
            measurementId: "G-ESZ1VB03MB"));
  } else {
    await Firebase.initializeApp();
  }
}
