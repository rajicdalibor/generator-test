import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:frontend/navigation/route_names.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class OnboardingWelcomePage extends ConsumerWidget {
  const OnboardingWelcomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context, ref) {
    var translation = AppLocalizations.of(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 24, bottom: 24),
              child: Center(
                child: Text(
                  translation!.welcomeText,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => context.go(routeOnboardingUser),
              child: Text(translation.continueLabel),
            ),
          ],
        ),
      ),
    );
  }
}
