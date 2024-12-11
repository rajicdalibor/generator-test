import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend/navigation/route_names.dart';
import 'package:frontend/providers/user_providers.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class VerificationPage extends ConsumerStatefulWidget {
  const VerificationPage({super.key});

  @override
  ConsumerState<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends ConsumerState<VerificationPage> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      debugPrint('Checking for email verification!');
      final authUser = await AuthService.reloadUser();
      if (authUser != null && authUser.emailVerified) {
        ref.read(authStateProvider.notifier).updateUser(authUser);
        timer.cancel();
        final appUser = ref.read(userProvider);
        if (mounted) {
          context.go(
              appUser?.onboarded == true ? routeHome : routeOnboardingWelcome);
        }
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authUser = ref.watch(authStateProvider);
    final translations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 24),
                child: Center(
                  child: Text(
                    translations.verificationPageTitle,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineMedium,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 24),
                child: Center(
                  child: Text(
                    translations.verificationPageDescription,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 24),
                child: Center(
                  child: ElevatedButton(
                      onPressed: () async {
                        await authUser?.sendEmailVerification();
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                translations.verificationEmailSent,
                              ),
                            ),
                          );
                        }
                      },
                      child: Text(translations.verificationPageButton)),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 24),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      await AuthService.signOut(context);
                    },
                    child: Text(translations.logoutLabel),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
