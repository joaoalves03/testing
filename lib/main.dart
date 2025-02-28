import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goipvc/themes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';
import 'generated/l10n.dart';
import 'package:logger/logger.dart';

import 'utils/shared_prefs.dart';

import 'ui/first_time.dart';
import 'ui/init_view.dart';
import 'ui/screens/login.dart';

import 'package:dynamic_color/dynamic_color.dart';

final Logger logger = Logger();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefsUtil.initializeDefaults();
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<Map<String, dynamic>> _getAppData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final bool isLoggedIn = prefs.getBool('is_logged_in') ?? false;
    final bool tosAccepted = prefs.getBool('tos_accepted') ?? false;
    final String theme = prefs.getString('theme') ?? 'light';
    final String colorScheme = prefs.getString('color_scheme') ?? 'school';
    final String schoolTheme = prefs.getString('school_theme') ?? 'IPVC';

    return {
      'isLoggedIn': isLoggedIn,
      'tosAccepted': tosAccepted,
      'theme': theme,
      'colorScheme': colorScheme,
      'schoolTheme': schoolTheme,
    };
  }

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        return FutureBuilder<Map<String, dynamic>>(
          future: _getAppData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const MaterialApp(
                  home: Scaffold(
                      body: Center(child: CircularProgressIndicator())));
            }

            final bool isLoggedIn = snapshot.data?['isLoggedIn'];
            final bool tosAccepted = snapshot.data?['tosAccepted'];
            final String theme = snapshot.data?['theme'];
            final String colorScheme = snapshot.data?['colorScheme'];
            final String schoolTheme = snapshot.data?['schoolTheme'];

            final ThemeMode themeMode = theme == 'system'
                ? ThemeMode.system
                : theme == 'dark'
                  ? ThemeMode.dark
                  : ThemeMode.light;

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
              theme: _buildTheme(
                lightDynamic,
                Brightness.light,
                colorScheme,
                schoolTheme,
              ),
              darkTheme: _buildTheme(
                darkDynamic,
                Brightness.dark,
                colorScheme,
                schoolTheme,
              ),
              themeMode: themeMode,
              debugShowCheckedModeBanner: false,
              home: isLoggedIn
                  ? (tosAccepted ? const InitView() : const FirstTimeScreen())
                  : const LoginScreen(),
              routes: getRoutes(),
            );
          },
        );
      },
    );
  }

  ThemeData _buildTheme(
      ColorScheme? dynamicColor,
      Brightness brightness,
      String colorSchemePref,
      String schoolTheme,
      ) {
    ColorScheme colorScheme;
    if (colorSchemePref == 'system' && dynamicColor != null) {
      colorScheme = ColorScheme.fromSeed(
        seedColor: dynamicColor.primary,
        brightness: brightness,
      );
    } else {
      return schoolThemes[schoolTheme][brightness == Brightness.dark ? 'dark' : 'light']!;
    }

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      tabBarTheme: TabBarTheme(
        unselectedLabelColor: colorScheme.onSurfaceVariant,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        strokeCap: StrokeCap.round,
      ),
    );
  }
}
