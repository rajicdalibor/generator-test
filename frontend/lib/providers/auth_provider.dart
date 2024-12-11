import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

final authStateProvider =
    StateNotifierProvider<AuthStateNotifier, User?>((ref) {
  return AuthStateNotifier();
});

class AuthStateNotifier extends StateNotifier<User?> {
  AuthStateNotifier() : super(null);

  bool get isLoggedIn => state != null;

  User? get loggedInUser => state;

  User? updateUser(User? newUser) {
    state = newUser;
    return newUser;
  }
}
