import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'providers/theme_provider.dart';
import 'providers/locale_provider.dart';
import 'screens/home_screen.dart';
import 'l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final themeProvider = ThemeProvider();
  final localeProvider = LocaleProvider();
  await Future.wait([themeProvider.load(), localeProvider.load()]);

  runApp(ProductsSearchApp(
    themeProvider: themeProvider,
    localeProvider: localeProvider,
  ));
}

class ProductsSearchApp extends StatelessWidget {
  final ThemeProvider themeProvider;
  final LocaleProvider localeProvider;

  const ProductsSearchApp({
    super.key,
    required this.themeProvider,
    required this.localeProvider,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: themeProvider),
        ChangeNotifierProvider.value(value: localeProvider),
      ],
      child: Consumer2<ThemeProvider, LocaleProvider>(
        builder: (context, theme, locale, _) {
          return MaterialApp(
            title: 'Products Search',
            debugShowCheckedModeBanner: false,
            themeMode: theme.mode,
            theme: theme.lightTheme,
            darkTheme: theme.darkTheme,
            locale: locale.locale,
            supportedLocales: LocaleProvider.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: const HomeShell(),
          );
        },
      ),
    );
  }
}
