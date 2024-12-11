import 'package:flutter/material.dart';
import 'package:frontend/providers/user_providers.dart';
import 'package:frontend/services/hello_world_service.dart';
import 'package:frontend/services/user_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/push_message.dart';
import '../services/firebase_functions_service.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final TextEditingController _userIdController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<String?> getHelloWorld() async {
    return await HelloWorldService.helloWorld();
  }

  sendNotificationToUser() async {
    if (_formKey.currentState!.validate()) {
      try {
        PushMessage message = PushMessage(
          dryRun: false,
          title: NotificationMessages.TEST_NOTIFICATION_TITLE.name,
          subtitle: NotificationMessages.TEST_NOTIFICATION_SUBTITLE.name,
          subtitleArgs: [],
          body: NotificationMessages.TEST_NOTIFICATION_BODY.name,
          userId: _userIdController.text,
          data: {},
        );
        await FirebaseFunctionsService.sendNotification(message);
        if (mounted) {
          final translations = AppLocalizations.of(context)!;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(translations.profilePageNotificationSent),
            ),
          );
        }
      } catch (e) {
        debugPrint('Error sending notification: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final translations = AppLocalizations.of(context)!;
    final user = ref.read(userProvider);

    return Scaffold(
      body: FutureBuilder<String?>(
        future: getHelloWorld(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.hasData && snapshot.data != null) {
            if (user != null) {
              UserService.updateInstalledAppVersion(user);
            }
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    Container(
                      margin: const EdgeInsets.only(bottom: 24),
                      child: Text(
                        translations.hello,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                    ),
                    Text(
                      snapshot.data!,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const Spacer(),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: SizedBox(
                              height: 60,
                              child: TextFormField(
                                controller: _userIdController,
                                decoration: InputDecoration(
                                  label: Text(translations
                                      .profilePageTestPushNotificationLabel),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return translations
                                        .profilePageTestPushNotificationError;
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: sendNotificationToUser,
                            child: Text(translations
                                .profilePageTestPushNotificationButton),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            );
          }

          return const Center(child: Text('No data available'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint('Hey hey hey');
        },
        child: const Icon(Icons.bubble_chart),
      ),
    );
  }
}
