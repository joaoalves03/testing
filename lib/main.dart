import 'dart:async';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goipvc/services/notifications.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:syncfusion_localizations/syncfusion_localizations.dart';
import 'firebase_options.dart';
import 'themes.dart';

import 'generated/l10n.dart';
import 'utils/shared_prefs.dart';
import 'ui/init_view.dart';
import 'ui/screens/login.dart';
import 'ui/widgets/logo.dart';

final Logger logger = Logger();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  }
  await SharedPrefsUtil.initializeDefaults();

  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  await Notifications.init();
  runApp(ProviderScope(child: App()));
}

class App extends StatefulWidget {
  const App({super.key});

  static AppState of(BuildContext context) =>
      context.findAncestorStateOfType<AppState>()!;

  @override
  AppState createState() => AppState();
}

class AppState extends State<App> {
  ThemeMode _themeMode = ThemeMode.system;
  String _colorScheme = 'school';
  String _schoolTheme = 'IPVC';

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _themeMode = (prefs.getString('theme') ?? 'system') == 'system'
          ? ThemeMode.system
          : (prefs.getString('theme') ?? 'system') == 'dark'
              ? ThemeMode.dark
              : ThemeMode.light;
      _colorScheme = prefs.getString('color_scheme') ?? 'school';
      _schoolTheme = prefs.getString('school_theme') ?? 'IPVC';
    });
  }

  void changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }

  void changeColorScheme(String colorScheme) {
    setState(() {
      _colorScheme = colorScheme;
    });
  }

  void changeSchoolTheme(String schoolTheme) {
    setState(() {
      _schoolTheme = schoolTheme;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
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
            _colorScheme,
            _schoolTheme,
          ),
          darkTheme: _buildTheme(
            darkDynamic,
            Brightness.dark,
            _colorScheme,
            _schoolTheme,
          ),
          themeMode: _themeMode,
          debugShowCheckedModeBanner: false,
          home: FutureBuilder<Map<String, dynamic>>(
            future: _getAppData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                    body: Center(
                        child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Logo(),
                    SizedBox(height: 10),
                    CircularProgressIndicator()
                  ],
                )));
              }

              final bool isLoggedIn = snapshot.data?['isLoggedIn'] ?? false;

              return isLoggedIn ? const InitView() : const LoginScreen();
            },
          ),
          routes: getRoutes(),
        );
      },
    );
  }

  Future<Map<String, dynamic>> _getAppData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final bool isLoggedIn = prefs.getBool('is_logged_in') ?? false;
    final String theme = prefs.getString('theme') ?? 'light';
    final String colorScheme = prefs.getString('color_scheme') ?? 'school';
    final String schoolTheme = prefs.getString('school_theme') ?? 'IPVC';

    return {
      'isLoggedIn': isLoggedIn,
      'theme': theme,
      'colorScheme': colorScheme,
      'schoolTheme': schoolTheme,
    };
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
      return schoolThemes[schoolTheme]
          [brightness == Brightness.dark ? 'dark' : 'light']!;
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
