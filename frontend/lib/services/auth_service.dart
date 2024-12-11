import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/navigation/route_names.dart';
import 'package:frontend/services/firebase_messaging_service.dart';
import 'package:frontend/services/user_service.dart';
import 'package:go_router/go_router.dart';

import '../exceptions/sign_in_exception.dart';
import '../providers/auth_provider.dart';
import '../utils/error_mapper.dart';

class AuthService {
  static FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final UserService userService = UserService();

  User? getCurrentUser() {
    return firebaseAuth.currentUser;
  }

  static authenticatedUserStream() => firebaseAuth
      .authStateChanges()
      .map<User?>((user) => AuthStateNotifier().updateUser(user));

  Future<void> registerNewUserWithEmailAndPassword(
      String emailAddress, String password) async {
    try {
      final UserCredential credential =
          await firebaseAuth.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      try {
        AppUser user = AppUser(
          id: credential.user!.uid,
          email: emailAddress,
        );
        await userService.create(user);
      } on FirebaseAuthException catch (error) {
        if (error.code == FirebaseAuthExceptionCodes.emailAlreadyInUse) {
          throw SignInException(SignInError.errorAlreadyUsedMail);
        }
        if (error.code == FirebaseAuthExceptionCodes.invalidEmail) {
          throw SignInException(SignInError.errorInvalidMail);
        }
        if (error.code == FirebaseAuthExceptionCodes.weakPassword) {
          throw SignInException(SignInError.errorWeakPassword);
        }
        if (error.code == FirebaseAuthExceptionCodes.tooManyRequests) {
          throw SignInException(SignInError.errorTooManyRequests);
        }
        throw SignInException(SignInError.errorExceptionWhileRegistering);
      }
    } catch (error) {
      throw SignInException(SignInError.errorExceptionWhileRegistering);
    }
  }

  Future<void> loginWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      if (result.user != null) {
        UserService.updateLastKnownActivity(result.user!.uid);
      }
      debugPrint('Logged in user with id: ${result.user!.uid}');
    } on FirebaseAuthException catch (error) {
      debugPrint('FirebaseAuthException: $error');
      if (error.code == FirebaseAuthExceptionCodes.invalidEmail) {
        throw SignInException(SignInError.errorInvalidMail);
      }
      if (error.code == FirebaseAuthExceptionCodes.userDisabled) {
        throw SignInException(SignInError.errorDisabledUser);
      }
      if (error.code == FirebaseAuthExceptionCodes.userNotFound) {
        throw SignInException(SignInError.errorNotFoundUser);
      }
      if (error.code == FirebaseAuthExceptionCodes.wrongPassword) {
        throw SignInException(SignInError.errorIncorrectPassword);
      }
      if (error.code == FirebaseAuthExceptionCodes.tooManyRequests) {
        throw SignInException(SignInError.errorTooManyRequests);
      }
      if (error.code == FirebaseAuthExceptionCodes.invalidLoginCredentials) {
        throw SignInException(SignInError.errorInvalidCredentials);
      }
      if (error.code == FirebaseAuthExceptionCodes.invalidCredential) {
        throw SignInException(SignInError.errorInvalidCredentials);
      }
      throw SignInException(SignInError.errorExceptionWhileLogin);
    } catch (error) {
      debugPrint('Error: $error');
    }
  }

  void sendEmailVerification() async {
    User? firebaseUser = getCurrentUser();
    if (firebaseUser != null && !firebaseUser.emailVerified) {
      // sendEmailVerification has parameter actionCodeSettings,
      // which can be used to redirect user to specific page after email verification
      await firebaseUser.sendEmailVerification();
    }
  }

  static Future<void> signOut(BuildContext context) async {
    try {
      // First remove token, because of update user firestore rules (requires to be authenticated)
      await FirebaseMessagingService.removeToken();
    } catch (e) {
      debugPrint('Error during sign out: $e');
    } finally {
      await firebaseAuth.signOut();
      if (context.mounted) {
        context.go(routeLogin);
      }
    }
  }

  static Future<User?> reloadUser() async {
    await FirebaseAuth.instance.currentUser!.reload();
    return FirebaseAuth.instance.currentUser;
  }
}

class FirebaseAuthExceptionCodes {
  static const String emailAlreadyInUse = 'email-already-in-use';
  static const String invalidEmail = 'invalid-email';
  static const String weakPassword = 'weak-password';
  static const String tooManyRequests = 'too-many-requests';
  static const String userDisabled = 'user-disabled';
  static const String userNotFound = 'user-not-found';
  static const String wrongPassword = 'wrong-password';
  static const String invalidLoginCredentials = 'INVALID_LOGIN_CREDENTIALS';
  static const String invalidCredential = 'invalid-credential';
}
