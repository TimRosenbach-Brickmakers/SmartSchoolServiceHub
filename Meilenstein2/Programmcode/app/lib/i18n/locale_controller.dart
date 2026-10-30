import 'dart:ui';
import 'package:flutter/foundation.dart';

// Singleton: null = der Systemsprache folgen
class LocaleController extends ChangeNotifier {
  LocaleController._();
  static final LocaleController instance = LocaleController._();

  static const supported = [Locale('de'), Locale('en')];
  Locale? _override;

  Locale get locale => _override ?? _fromSystem();

  Locale _fromSystem() {
    final sys = PlatformDispatcher.instance.locale;
    return supported.firstWhere((l) => l.languageCode == sys.languageCode,
        orElse: () => supported.first);
  }

  void setLocale(Locale? locale) {
    _override = locale;
    notifyListeners();
  }
}
