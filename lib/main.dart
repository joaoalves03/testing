import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';
import 'generated/l10n.dart';
import 'package:logger/logger.dart';

import 'utils/shared_prefs.dart';

import 'ui/init_view.dart';
import 'ui/screens/login.dart';

import 'package:dynamic_color/dynamic_color.dart';

final Logger logger = Logger();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPrefsUtil.printPrefs();
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> _checkLoginStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_logged_in') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        return FutureBuilder<bool>(
          future: _checkLoginStatus(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const MaterialApp(
                  home: Scaffold(
                      body: Center(child: CircularProgressIndicator())));
            }

            final bool isLoggedIn = snapshot.data ?? false;
            return MaterialApp(
              title: 'goIPVC',
              localizationsDelegates: const [
                S.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                SfGlobalLocalizations.delegate
              ],
              supportedLocales: S.delegate.supportedLocales,
              theme: _buildTheme(lightDynamic, Brightness.light),
              darkTheme: _buildTheme(darkDynamic, Brightness.dark),
              themeMode: ThemeMode.system,
              debugShowCheckedModeBanner: false,
              home: isLoggedIn ? const InitView() : const LoginScreen(),
              routes: getRoutes(),
            );
          },
        );
      },
    );
  }

  ThemeData _buildTheme(ColorScheme? dynamicColor, Brightness brightness) {
    ColorScheme colorScheme;
    if (dynamicColor != null) {
      colorScheme = ColorScheme.fromSeed(
          seedColor: dynamicColor.primary, brightness: brightness);
    } else {
      colorScheme = ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: brightness,
      );
    }

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
    );
  }
}
