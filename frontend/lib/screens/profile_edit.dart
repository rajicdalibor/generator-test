import 'package:flutter/material.dart';
import 'package:frontend/components/address_autocomplete/address_autocomplete.dart';
import 'package:frontend/components/date_picker.dart';
import 'package:frontend/models/address_suggestion.dart';
import 'package:frontend/models/place.dart';
import 'package:frontend/providers/user_providers.dart';
import 'package:frontend/services/user_service.dart';
import 'package:frontend/utils/date_utils.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileEditPage extends ConsumerStatefulWidget {
  const ProfileEditPage({super.key});

  @override
  ConsumerState<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends ConsumerState<ProfileEditPage> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _userLastNameController = TextEditingController();
  final TextEditingController _userBirthDateController =
      TextEditingController();
  AddressSuggestion? _addressSuggestion;
  Place? _place;
  final _addressCtrl = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final user = ref.read(userProvider);
    _userNameController.text = user?.firstName ?? '';
    _userLastNameController.text = user?.lastName ?? '';
    _userBirthDateController.text = user?.birthDate ?? '';
    if (user?.googleAddress != null) {
      _addressCtrl.text = user?.googleAddress!.fullAddress ?? '';
    }
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _userLastNameController.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  void submit() {
    if (_formKey.currentState!.validate()) {
      final onboardingUser = ref.watch(userProvider.notifier);
      onboardingUser.setName(_userNameController.text);
      onboardingUser.setLastName(_userLastNameController.text);
      onboardingUser.setBirthDate(_userBirthDateController.text);
      if (_place != null) {
        onboardingUser.setGoogleAddress(_place!);
      }
      if (onboardingUser.user != null) {
        UserService.updateUser(onboardingUser.user!);
        context.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var translations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(translations.profileEditPage),
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
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
                      padding: const EdgeInsets.only(bottom: 16),
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
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: AddressAutocomplete(
                        controller: _addressCtrl,
                        addressSuggestion: _addressSuggestion,
                        onAddressChanged: (AddressSuggestion? result) {
                          setState(() {
                            _addressSuggestion = result;
                          });
                        },
                        onPlaceChanged: (Place place) {
                          setState(() {
                            _place = place;
                          });
                        },
                        labelText: translations.profilePageAddressLabel,
                        hintText: translations.profilePageAddressHint,
                        searchHintTitle:
                            translations.profilePageAddressSearchTitle,
                        searchHintDescription:
                            translations.profilePageAddressSearchDescription,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: submit,
                      child: Text(translations.commonSubmit),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
