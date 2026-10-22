import 'package:flutter/cupertino.dart'
    show CupertinoLocalizations, DefaultCupertinoLocalizations;
import 'package:flutter/foundation.dart' show SynchronousFuture;
import 'package:flutter/material.dart';

import 'kannada_strings.dart';

/// Looks up UI text for the active [Locale].
///
/// **How it works:** the English text itself is the key. In a widget write
/// `context.tr('Welcome Back')`. For English that returns the same text; for
/// Kannada it returns the matching entry from `kannada_strings.dart`, and
/// falls back to the English text if no translation exists yet (so a missing
/// entry never shows a blank).
///
/// Dynamic values use `{placeholders}` that appear in both languages:
/// ```dart
/// context.tr('Code sent to {email}', args: {'email': email})
/// ```
///
/// The app locale lives in `appLocaleProvider` (see `locale_provider.dart`)
/// and is applied in `app.dart`, so changing it rebuilds every widget that
/// called `context.tr`.
class AppLocalizations {
  final Locale locale;

  const AppLocalizations(this.locale);

  static const Locale english = Locale('en');
  static const Locale kannada = Locale('kn');
  static const List<Locale> supportedLocales = [english, kannada];

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// Everything `MaterialApp.localizationsDelegates` needs.
  ///
  /// The three `_Fallback*` delegates exist because Flutter's own Material /
  /// Widgets / Cupertino strings are only bundled for English unless the
  /// `flutter_localizations` package is added. They make those widgets keep
  /// working (with English built-in labels) while the locale is Kannada.
  /// If `flutter_localizations` is added later, replace them with
  /// `GlobalMaterialLocalizations.delegate` and friends.
  static const List<LocalizationsDelegate<dynamic>> delegates = [
    delegate,
    _FallbackMaterialDelegate(),
    _FallbackWidgetsDelegate(),
    _FallbackCupertinoDelegate(),
  ];

  bool get isKannada => locale.languageCode == kannada.languageCode;

  /// The [AppLocalizations] for [context]; English when none is installed
  /// (e.g. a widget built outside the app's `MaterialApp`).
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        const AppLocalizations(english);
  }

  /// Translates [text] (the English original). [args] replaces `{name}`
  /// placeholders.
  String tr(String text, {Map<String, Object>? args}) {
    var result = isKannada ? (kannadaStrings[text] ?? text) : text;
    if (args != null) {
      args.forEach((name, value) {
        result = result.replaceAll('{$name}', '$value');
      });
    }
    return result;
  }
}

/// `context.tr('English text')`.
extension AppLocalizationsContext on BuildContext {
  String tr(String text, {Map<String, Object>? args}) =>
      AppLocalizations.of(this).tr(text, args: args);
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => AppLocalizations.supportedLocales.any(
    (supported) => supported.languageCode == locale.languageCode,
  );

  @override
  Future<AppLocalizations> load(Locale locale) =>
      SynchronousFuture(AppLocalizations(locale));

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

// ─── Built-in Flutter strings for Kannada (English fallback) ────────────

class _FallbackMaterialDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const _FallbackMaterialDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'kn';

  @override
  Future<MaterialLocalizations> load(Locale locale) =>
      SynchronousFuture(const DefaultMaterialLocalizations());

  @override
  bool shouldReload(_FallbackMaterialDelegate old) => false;
}

class _FallbackWidgetsDelegate
    extends LocalizationsDelegate<WidgetsLocalizations> {
  const _FallbackWidgetsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'kn';

  @override
  Future<WidgetsLocalizations> load(Locale locale) =>
      SynchronousFuture(const DefaultWidgetsLocalizations());

  @override
  bool shouldReload(_FallbackWidgetsDelegate old) => false;
}

class _FallbackCupertinoDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const _FallbackCupertinoDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'kn';

  @override
  Future<CupertinoLocalizations> load(Locale locale) =>
      SynchronousFuture(const DefaultCupertinoLocalizations());

  @override
  bool shouldReload(_FallbackCupertinoDelegate old) => false;
}
