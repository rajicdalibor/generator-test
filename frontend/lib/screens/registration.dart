import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frontend/navigation/route_names.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../exceptions/sign_in_exception.dart';
import '../services/auth_service.dart';
import '../utils/error_mapper.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final _passwordFocusNode = FocusNode();
  final authService = AuthService();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    debugPrint('RegistrationPage disposed');
    _emailController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  String? validateEmail(String? email, AppLocalizations translations) {
    if (email != null && email.isEmpty) {
      return translations.emailIsEmptyError;
    }
    const emailRegex =
        r'^[a-zA-Z0-9.!#$%&*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?\.[a-zA-Z]{2,}$';
    if (email != null && !RegExp(emailRegex).hasMatch(email)) {
      return translations.errorInvalidMail;
    }
    return null;
  }

  String? validatePassword(String? password, AppLocalizations translations) {
    if (password != null && password.isEmpty) {
      return translations.passwordIsEmptyError;
    }
    if (password != null && (password.length < 6 || password.length > 30)) {
      return translations.passwordLengthError;
    }
    return null;
  }

  String? validateConfirmPassword(
      String? password, AppLocalizations translations) {
    if (password != null && password.isEmpty) {
      return translations.passwordIsEmptyError;
    }
    if (password != null && password != _passwordController.text) {
      return translations.passwordsDoNotMatchError;
    }
    return null;
  }

  void onProceed() {
    if (context.mounted) {
      context.go(routeVerification);
    }
  }

  submit() async {
    try {
      if (_formKey.currentState!.validate()) {
        await authService.registerNewUserWithEmailAndPassword(
            _emailController.text, _passwordController.text);
        authService.sendEmailVerification();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizations.of(context)!.verificationEmailSent,
              ),
            ),
          );
        }
        onProceed();
      }
    } on FirebaseAuthException catch (error) {
      debugPrint("Exception: $error");
      rethrow;
    } on SignInException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              ErrorMapper.mapRegistrationAndLoginErrors(
                context,
                error.message,
              ),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final translations = AppLocalizations.of(context)!;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 24),
                child: Center(
                  child: Text(
                    translations.registrationPageTitle,
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
                          controller: _emailController,
                          decoration: InputDecoration(
                            label: Text(translations.emailLabel),
                          ),
                          validator: (value) =>
                              validateEmail(value, translations),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: SizedBox(
                        height: 60,
                        child: TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            label: Text(translations.passwordLabel),
                          ),
                          obscureText: true,
                          validator: (value) =>
                              validatePassword(value, translations),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: SizedBox(
                        height: 60,
                        child: TextFormField(
                          controller: _confirmPasswordController,
                          decoration: InputDecoration(
                            label: Text(translations.confirmPasswordLabel),
                          ),
                          obscureText: true,
                          validator: (value) =>
                              validateConfirmPassword(value, translations),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: submit,
                      child: Text(translations.commonSubmit),
                    ),
                    ElevatedButton(
                      onPressed: () => context.go(routeHome),
                      child: Text(translations.registrationPageNavLogin),
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
