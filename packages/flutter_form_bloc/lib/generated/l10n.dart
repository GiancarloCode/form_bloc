// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

class FormBlocLocalizations {
  FormBlocLocalizations(this.localeName);
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<FormBlocLocalizations> load(Locale locale) {
    final String name = locale.countryCode.isEmpty ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      return FormBlocLocalizations(localeName);
    });
  } 

  static FormBlocLocalizations of(BuildContext context) {
    return Localizations.of<FormBlocLocalizations>(context, FormBlocLocalizations);
  }

  final String localeName;

  String get requiredInputFieldBloc {
    return Intl.message(
      'This field is required.',
      name: 'requiredInputFieldBloc',
      desc: '',
      args: [],
    );
  }

  String get requiredBooleanFieldBloc {
    return Intl.message(
      'This field is required.',
      name: 'requiredBooleanFieldBloc',
      desc: '',
      args: [],
    );
  }

  String get requiredTextFieldBloc {
    return Intl.message(
      'This field is required.',
      name: 'requiredTextFieldBloc',
      desc: '',
      args: [],
    );
  }

  String get requiredSelectFieldBloc {
    return Intl.message(
      'Please select an option.',
      name: 'requiredSelectFieldBloc',
      desc: '',
      args: [],
    );
  }

  String get requiredMultiSelectFieldBloc {
    return Intl.message(
      'Please select an option.',
      name: 'requiredMultiSelectFieldBloc',
      desc: '',
      args: [],
    );
  }

  String get email {
    return Intl.message(
      'The email address is badly formatted.',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  String get passwordMin6Chars {
    return Intl.message(
      'The password must contain at least 6 characters.',
      name: 'passwordMin6Chars',
      desc: '',
      args: [],
    );
  }

  String get confirmPassword {
    return Intl.message(
      'Must be equal to password.',
      name: 'confirmPassword',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<FormBlocLocalizations> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale('en', ''), Locale('it', ''),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<FormBlocLocalizations> load(Locale locale) => FormBlocLocalizations.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (Locale supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}