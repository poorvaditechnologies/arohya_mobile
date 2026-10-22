import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_localizations.dart';

/// Holds the app's active language. Both language switchers (onboarding and
/// home) change it, and `ArohyaApp` feeds it to `MaterialApp.locale`.
///
/// Not persisted yet: the app starts in English on every launch.
class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(AppLocalizations.english);

  void setLocale(Locale locale) => state = locale;

  void toggle() {
    state = state.languageCode == AppLocalizations.kannada.languageCode
        ? AppLocalizations.english
        : AppLocalizations.kannada;
  }
}

final appLocaleProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});
