import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:frontend/navigation/route_names.dart';
import 'package:frontend/utils/date_utils.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../components/date_picker.dart';
import '../../providers/user_providers.dart';
import '../../services/user_service.dart';

class OnboardingUserPage extends ConsumerStatefulWidget {
  const OnboardingUserPage({super.key});

  @override
  ConsumerState<OnboardingUserPage> createState() => _OnboardingUserPageState();
}

class _OnboardingUserPageState extends ConsumerState<OnboardingUserPage> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _userLastNameController = TextEditingController();
  final TextEditingController _userBirthDateController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _userNameController.dispose();
    _userLastNameController.dispose();
    super.dispose();
  }

  void onNext() {
    if (_formKey.currentState!.validate()) {
      final onboardingUser = ref.watch(userProvider.notifier);
      onboardingUser.setName(_userNameController.text);
      onboardingUser.setLastName(_userLastNameController.text);
      onboardingUser.setBirthDate(_userBirthDateController.text);
      onboardingUser.setOnboarded(true);
      if (onboardingUser.user != null) {
        UserService.updateUser(onboardingUser.user!);
        context.go(routeHome);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var translations = AppLocalizations.of(context)!;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 24, bottom: 24),
                child: Center(
                  child: Text(
                    translations.onboardingDescription,
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: SizedBox(
                        height: 60,
                        child: TextFormField(
                          controller: _userNameController,
                          decoration: InputDecoration(
                            label: Text(translations.firstNameLabel),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return translations.firstNameIsEmpty;
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: SizedBox(
                        height: 60,
                        child: TextFormField(
                          controller: _userLastNameController,
                          decoration: InputDecoration(
                            label: Text(translations.lastNameLabel),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return translations.lastNameIsEmpty;
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: SizedBox(
                        height: 60,
                        child: DatePickerFormField(
                          controller: _userBirthDateController,
                          label: translations.birthdateLabel,
                          validator: (date) => validateDate(date, translations),
                          marginBottom: 50,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: onNext,
                      child: Text(translations.continueLabel),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
