import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OnboardingTemplate extends ConsumerWidget {
  const OnboardingTemplate({
    super.key,
    required this.child,
  });
  final Widget child;

  @override
  Widget build(BuildContext context, ref) {
    final translations = AppLocalizations.of(context)!;

    return Scaffold(
      body: Center(
        child: child,
      ),
      appBar: AppBar(
        title: Text(translations.onboardingTitle),
      ),
    );
  }
}
