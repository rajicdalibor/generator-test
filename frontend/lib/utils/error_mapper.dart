import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum SignInError {
  errorInvalidMail,
  errorAlreadyUsedMail,
  errorWeakPassword,
  errorTooManyRequests,
  errorExceptionWhileRegistering,
  errorExceptionWhileRegisteringWithTryAgain,
  errorDisabledUser,
  errorNotFoundUser,
  errorIncorrectPassword,
  errorInvalidCredentials,
  errorExceptionWhileLogin,
  errorGoogleSignInAborted,
  errorAppleSignInAborted,
  errorFacebookSignInAborted,
}

class ErrorMapper {
  static String mapRegistrationAndLoginErrors(
      BuildContext context, SignInError key) {
    var translations = AppLocalizations.of(context)!;
    switch (key) {
      case SignInError.errorInvalidMail:
        return translations.errorInvalidMail;
      case SignInError.errorAlreadyUsedMail:
        return translations.errorAlreadyUsedMail;
      case SignInError.errorWeakPassword:
        return translations.errorWeakPassword;
      case SignInError.errorTooManyRequests:
        return translations.errorTooManyRequests;
      case SignInError.errorExceptionWhileRegistering:
        return translations.errorExceptionWhileRegistering;
      case SignInError.errorExceptionWhileRegisteringWithTryAgain:
        return translations.errorExceptionWhileRegisteringWithTryAgain;
      case SignInError.errorDisabledUser:
        return translations.errorDisabledUser;
      case SignInError.errorNotFoundUser:
        return translations.errorNotFoundUser;
      case SignInError.errorIncorrectPassword:
        return translations.errorIncorrectPassword;
      case SignInError.errorInvalidCredentials:
        return translations.errorInvalidCredentials;
      case SignInError.errorExceptionWhileLogin:
        return translations.errorExceptionWhileLogin;
      case SignInError.errorGoogleSignInAborted:
        return translations.errorGoogleSignInAborted;
      case SignInError.errorAppleSignInAborted:
        return translations.errorAppleSignInAborted;
      case SignInError.errorFacebookSignInAborted:
        return translations.errorFacebookSignInAborted;
      default:
        return '';
    }
  }
}
