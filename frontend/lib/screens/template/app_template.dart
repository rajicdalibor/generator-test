import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/navigation/route_names.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/services/user_service.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AppTemplate extends ConsumerWidget {
  const AppTemplate({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context, ref) {
    final authState = ref.watch(authStateProvider);
    final translations = AppLocalizations.of(context)!;

    return StreamBuilder<AppUser?>(
      stream: UserService.getUserStream(authState?.uid),
      builder: (context, AsyncSnapshot<AppUser?> snapshot) {
        AppUser? appUser;
        if (snapshot.hasData) {
          appUser = snapshot.data!;
        }

        if (appUser != null) {
          return Scaffold(
            body: child,
            appBar: AppBar(
              title: Text(translations.title),
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _getSelectedIndex(context),
              onTap: (index) => _onItemTapped(context, index),
              items: [
                BottomNavigationBarItem(
                  icon: const Icon(Icons.home),
                  label: translations.navMenuItemHome,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.person),
                  label: translations.navMenuItemProfile,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.settings),
                  label: translations.navMenuItemSettings,
                ),
              ],
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}

// Handles tapping on bottom navigation items
void _onItemTapped(BuildContext context, int index) {
  switch (index) {
    case 0:
      context.go(routeHome);
      break;
    case 1:
      context.go(routeProfile);
      break;
    case 2:
      context.go(routeSettings);
      break;
  }
}

// Gets the selected index for the bottom navigation bar based on the current route
int _getSelectedIndex(BuildContext context) {
  final String location =
      GoRouter.of(context).routerDelegate.currentConfiguration.fullPath;
  // Determine the selected index based on the current route
  if (location == routeHome) {
    return 0; // Home selected
  } else if (location == routeProfile) {
    return 1; // Profile selected
  } else if (location == routeSettings) {
    return 2; // Settings selected
  }
  return 0; // Default to Home if no match
}
