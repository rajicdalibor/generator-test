import 'package:flutter/foundation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateAppPage extends StatelessWidget {
  static const String playStore = String.fromEnvironment('PLAY_STORE_APP_URL');
  static const String appStore = String.fromEnvironment('APP_STORE_APP_URL');

  const UpdateAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    final translations = AppLocalizations.of(context)!;
    final isAndroid = defaultTargetPlatform == TargetPlatform.android;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  translations.updateAppPageTitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 48),
                child: Text(
                  translations.updateAppPageDescription,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (isAndroid) {
                    await launchUrl(Uri.parse(playStore));
                  } else {
                    await launchUrl(Uri.parse(appStore));
                  }
                },
                child: Text(translations.updateAppPageButton),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
