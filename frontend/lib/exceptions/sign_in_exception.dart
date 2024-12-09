import 'package:frontend/utils/error_mapper.dart';

class SignInException implements Exception {
  final SignInError message;

  SignInException(this.message);
}
