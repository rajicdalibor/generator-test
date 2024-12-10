import 'package:frontend/services/firebase_functions_service.dart';

class HelloWorldService {
  static Future<String?> helloWorld() async {
    return await FirebaseFunctionsService.helloWorld();
  }
}
