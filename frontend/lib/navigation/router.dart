import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frontend/navigation/route_names.dart';
import 'package:frontend/providers/user_providers.dart';
import 'package:frontend/screens/home.dart';
import 'package:frontend/screens/profile.dart';
import 'package:frontend/screens/login.dart';
import 'package:frontend/screens/profile_edit.dart';
import 'package:frontend/screens/registration.dart';
import 'package:frontend/screens/settings.dart';
import 'package:frontend/screens/template/app_template.dart';
import 'package:frontend/screens/verification.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../screens/onboarding/onboarding_user.dart';
import '../screens/onboarding/onboarding_welcome.dart';
import '../screens/template/onboarding_template.dart';

// List of the routes for the app
final List<RouteBase> routes = [
  GoRoute(
    path: routeLogin,
    builder: (context, state) => const LoginPage(),
  ),
  GoRoute(
    path: routeRegistration,
    builder: (context, state) => const RegistrationPage(),
  ),
  GoRoute(
    path: routeProfileEdit,
    builder: (context, state) => const ProfileEditPage(),
  ),
  GoRoute(
    path: routeVerification,
    builder: (context, state) => const VerificationPage(),
  ),
  // ShellRoute for the onboarding pages
  ShellRoute(
    builder: (context, state, child) {
      return OnboardingTemplate(child: child);
    },
    routes: [
      GoRoute(
        path: routeOnboardingWelcome,
        builder: (context, state) =>
            const OnboardingWelcomePage(), // Display the HomePage widget
      ),
      GoRoute(
        path: routeOnboardingUser,
        builder: (context, state) =>
            const OnboardingUserPage(), // Display the ProfilePage widget
      ),
    ],
  ),
  // ShellRoute for the main app structure with navigation
  ShellRoute(
    builder: (context, state, child) {
      return AppTemplate(child: child);
    },
    routes: [
      GoRoute(
        path: routeHome,
        builder: (context, state) =>
            const HomePage(), // Display the HomePage widget
      ),
      GoRoute(
        path: routeProfile,
        builder: (context, state) =>
            const ProfilePage(), // Display the ProfilePage widget
      ),
      GoRoute(
        path: routeSettings,
        builder: (context, state) => const SettingsPage(),
      ),
    ],
  ),
];

// Global key to manage the navigator state
final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  initialLocation: routeHome,
  navigatorKey: _navigatorKey,
  routes: routes,
  redirect: (context, state) {
    final authUser = FirebaseAuth.instance.currentUser;
    final user = ProviderScope.containerOf(context).read(userProvider);
    if (authUser == null) {
      if ([routeLogin, routeRegistration].contains(state.fullPath)) {
        return null;
      } else {
        return routeLogin;
      }
    } else if (authUser.emailVerified == false) {
      return routeVerification;
    } else if (user != null && user.onboarded == false) {
      if ([routeOnboardingWelcome, routeOnboardingUser]
          .contains(state.fullPath)) {
        return null;
      } else {
        return routeOnboardingWelcome;
      }
    }

    return null;
  },
);
