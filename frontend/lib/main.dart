import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:frontend/app.dart';
import 'package:frontend/firebase_options.dart';
import 'package:frontend/services/firebase_messaging_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessagingService.setupPermissions();
  FirebaseMessagingService.setupAutoInitEnabled();
  FirebaseMessaging.onBackgroundMessage(
      FirebaseMessagingService.firebaseMessagingBackgroundHandler);

  // The 'USE_EMULATOR' environment variable determines whether to use the
  // Firebase Emulator Suite for local development.
  // To set this flag from the command line, use:
  // `--dart-define=USE_EMULATOR=true`
  const bool useFirebaseEmulator =
      bool.fromEnvironment('USE_EMULATOR', defaultValue: false);
  if (useFirebaseEmulator) {
    FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
    await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
    FirebaseFunctions.instanceFor(region: "europe-west6")
        .useFunctionsEmulator('localhost', 5001);
    FirebaseStorage.instance.useStorageEmulator('localhost', 9199);
  }
  runApp(const ProviderScope(child: App()));
}
