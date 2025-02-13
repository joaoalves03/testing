import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';
import 'generated/l10n.dart';
import 'package:logger/logger.dart';

import 'utils/shared_prefs.dart';

import 'ui/init_view.dart';
import 'ui/screens/login.dart';

final Logger logger = Logger();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPrefsUtil.printPrefs();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> _checkLoginStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_logged_in') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: _checkLoginStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return MaterialApp(home: CircularProgressIndicator());
          } else {
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
                theme: ThemeData.light(),
                darkTheme: ThemeData.dark(),
                themeMode: ThemeMode.system,
                debugShowCheckedModeBanner: false,
                home: isLoggedIn ? InitView() : LoginScreen(),
                routes: getRoutes()
            );
          }
        });
  }
}
