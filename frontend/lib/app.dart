import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:frontend/models/upgrade_version.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/providers/local_provider.dart';
import 'package:frontend/providers/user_providers.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/services/firebase_messaging_service.dart';
import 'package:frontend/services/user_service.dart';
import 'package:frontend/providers/theme_provider.dart';
import 'package:frontend/screens/update_app.dart';
import 'package:frontend/services/update_app_service.dart';
import 'package:frontend/utils/theme.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'navigation/router.dart';

class App extends ConsumerStatefulWidget {
  const App({
    super.key,
  });

  @override
  ConsumerState<App> createState() => AppState();
}

class AppState extends ConsumerState<App> with WidgetsBindingObserver {
  StreamSubscription<AppUser?>? subscription;
  Future<UpgradeVersion> _futureUpgradeApp =
      UpdateAppService.getLatestVersion();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    AuthService.authenticatedUserStream().listen((User? user) async {
      if (user == null) {
        ref.read(authStateProvider.notifier).updateUser(user);
        ref.read(userProvider.notifier).setUser(null);
        subscription?.cancel();
      } else {
        ref.read(authStateProvider.notifier).updateUser(user);
        await FirebaseMessagingService.setupToken();

        subscription = UserService.currentAppUserStream().listen((user) {
          ref.read(userProvider.notifier).setUser(user);
        });
      }
    });
    FirebaseMessagingService.setupInteractedMessage(router, ref);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      var user = ref.read(userProvider);
      if (user != null) {
        await UserService.updateLastKnownActivity(user.id!);
      }
      setState(() {
        _futureUpgradeApp = UpdateAppService.getLatestVersion();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeProvider);
    final themeBrightness = ref.watch(themeProvider);

    return MaterialApp.router(
      title: 'App in a box',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: locale.getLocale(),
      theme: ThemeUtil.createThemeData(
        // https://m3.material.io/styles/color/roles
        // Use the Material Design color roles to create a color scheme
        ColorScheme.fromSeed(
          seedColor: Colors.blue[600]!,
          brightness: themeBrightness,
          dynamicSchemeVariant: DynamicSchemeVariant.tonalSpot,
        ),
      ),
      builder: (context, child) {
        // Check if the app needs to be updated
        // Can be changed to StreamBuilder if the app needs to check for updates periodically
        return FutureBuilder(
          future: _futureUpgradeApp,
          builder: (context, updateSnapshot) {
            if (updateSnapshot.hasData) {
              final upgradeVersion = updateSnapshot.data!;
              if (upgradeVersion.isUpgradeRequired) {
                return const UpdateAppPage();
              }
            }

            return child ?? const SizedBox.shrink();
          },
        );
      },
      routerConfig: router,
    );
  }
}
