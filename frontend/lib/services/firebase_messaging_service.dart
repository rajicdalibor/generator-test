import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';

import '../firebase_options.dart';
import 'user_service.dart';

class FirebaseMessagingService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;

  static Future<void> setupPermissions() async {
    try {
      debugPrint('>> _setupPermissions');
      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      debugPrint('>> User granted permission: ${settings.authorizationStatus}');
      await messaging.setForegroundNotificationPresentationOptions(
        alert: true, // Required to display a heads up notification
        badge: true,
        sound: true,
      );

      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'app_priority_channel', // id
        'App Notification Channel', // title
        importance: Importance.max,
      );
      final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          FlutterLocalNotificationsPlugin();

      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    } catch (err) {
      debugPrint('Error setupPermissions: $err');
    }
  }

  static Future<void> setupAutoInitEnabled() async {
    try {
      debugPrint('Setting auto init enabled');
      await messaging.setAutoInitEnabled(true);
    } catch (err) {
      debugPrint('Err setting auto init enabled $err');
    }
  }

  static Future<void> setupToken() async {
    try {
      debugPrint('>> setupToken');
      // Get the token each time the application loads
      final String? token = await messaging.getToken();

      // For apple platforms, ensure the APNS token is available before making any FCM plugin API calls

      if (token != null) {
        // APNS token is available, make FCM plugin API requests...
        debugPrint('>> New token available: $token');
        // Save the initial token to the database
        await _saveTokenToDatabase(token);
      }

      // Any time the token refreshes, store this in the database too.
      messaging.onTokenRefresh.listen(_saveTokenToDatabase).onError((err) {
        // Error getting token.
        debugPrint('>> Error getting token:\n$err');
      });
    } catch (err) {
      debugPrint('Error _setupToken: $err');
    }
  }

  static Future<void> removeToken() async {
    debugPrint('>> removeToken');
    final String? token = await messaging.getToken();

    if (token != null) {
      try {
        await UserService.removeToken(token);
      } catch (err) {
        debugPrint('Error removeToken: $err');
      }
    }
  }

  /// waking up from a terminated state
  static Future<void> setupInteractedMessage(GoRouter router, ref) async {
    try {
      debugPrint('>> _setupInteractedMessage');
      // Get any messages which caused the application to open from
      // a terminated state.
      RemoteMessage? initialMessage =
          await FirebaseMessaging.instance.getInitialMessage();

      // If the message also contains a data property with a "type" of "chat",
      // navigate to a chat screen
      if (initialMessage != null) {
        debugPrint('>> called from terminated state: ${initialMessage.data}');
        await _handleBackgroundMessage(initialMessage, router, ref);
      }

      // Also handle any interaction when the app is in the background via a
      // Stream listener
      FirebaseMessaging.onMessageOpenedApp.listen((event) async {
        debugPrint('>> onMessageOpenedApp: $event');
        await _handleBackgroundMessage(event, router, ref);
      });
    } catch (err) {
      debugPrint('Error _setupInteractedMessage: $err');
    }
  }

  @pragma('vm:entry-point')
  static Future<void> firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    try {
      debugPrint('>> _firebaseMessagingBackgroundHandler: $message');
      // If you're going to use other Firebase services in the background, such as Firestore,
      // make sure you call `initializeApp` before using other Firebase services.
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      debugPrint('>> Background message: ${message.messageId}');
    } catch (err) {
      debugPrint('Error firebaseMessagingBackgroundHandler: $err');
    }
  }

  /// Method stores the registration token of the database to the user collection
  static Future<void> _saveTokenToDatabase(String token) async {
    try {
      debugPrint('>> _saveTokenToDatabase $token');

      UserService.updateToken(token);
    } catch (err) {
      debugPrint('Error _saveTokenToDatabase: $err');
    }
  }

  static Future _handleBackgroundMessage(
      RemoteMessage message, GoRouter router, ref) async {
    var route = message.data['route'];
    debugPrint('>> Handling background message: $route');
    debugPrint('>> Navigating with data ${message.data}');
    //TODO: handle routing
  }
}
