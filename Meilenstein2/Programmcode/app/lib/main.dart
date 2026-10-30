import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'i18n/generated/app_localizations.dart';
import 'i18n/locale_controller.dart';

void main() => runApp(const SmartSchoolApp());

class SmartSchoolApp extends StatelessWidget {
  const SmartSchoolApp({super.key});

  @override
  Widget build(BuildContext context) {
    final lc = LocaleController.instance;
    return ListenableBuilder(
      listenable: lc,
      builder: (context, _) => MaterialApp(
        locale: lc.locale,
        supportedLocales: LocaleController.supported,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: const PlaceholderScreen(),
      ),
    );
  }
}

// TODO: echte Screens in view/
class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final lc = LocaleController.instance;
    return Scaffold(
      appBar: AppBar(title: Text(t.appTitleName)),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(t.dashboardScreenTitle),
            const SizedBox(height: 16),
            Text(t.appLanguageLabel),
            Wrap(spacing: 8, children: [
              TextButton(onPressed: () => lc.setLocale(const Locale('de')), child: const Text('Deutsch')),
              TextButton(onPressed: () => lc.setLocale(const Locale('en')), child: const Text('English')),
              TextButton(onPressed: () => lc.setLocale(null), child: Text(t.appLanguageSystem)),
            ]),
          ],
        ),
      ),
    );
  }
}
