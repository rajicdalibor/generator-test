import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:frontend/models/push_message.dart';

class FirebaseFunctionsService {
  static const String functionRegion = 'europe-west6';
  static final FirebaseFunctions _functions =
      FirebaseFunctions.instanceFor(region: functionRegion);

  static Future<String?> helloWorld() async {
    try {
      final func =
          _functions.httpsCallable(FirebaseFunctionsConstants.helloWorld);
      final response = await func.call();
      return response.data;
    } catch (error) {
      debugPrint("Error getting hello world response: $error");
      return null;
    }
  }

  static Future<void> sendNotification(PushMessage message) async {
    final func = _functions
        .httpsCallable(FirebaseFunctionsConstants.sendPushNotificationCallable);
    await func.call(message.toJson());
  }
}

class FirebaseFunctionsConstants {
  static const String helloWorld = "helloWorldCallable";
  static const String sendPushNotificationCallable =
      "sendPushNotificationCallable";
}
