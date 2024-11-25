import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'generated/l10n.dart';
import 'package:logger/logger.dart';

import '/utils/shared_prefs.dart';
import 'ui/screens/login.dart';
import 'ui/screens/home.dart';

final Logger logger = Logger();

void main() => runApp(const Main());

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'goIPVC',
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: const RootPage(),
    );
  }
}

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _initializePrefs();
    SharedPrefsUtil.printPrefs();
  }

  Future<void> _initializePrefs() async {
    _prefs = await SharedPreferences.getInstance();
    _defaultPrefs();
    _checkLoginStatus();
  }

  Future<void> _defaultPrefs() async {
    if (_prefs.getString('layout') == null) {
      await _prefs.setString('layout', 'IPVC');
    }
  }

  bool _isLoggedIn = false;
  Future<void> _checkLoginStatus() async {
    bool isLoggedIn = _prefs.getBool('isLoggedIn') ?? false;
    setState(() {
      _isLoggedIn = isLoggedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoggedIn) {
      return HomeScreen();
    } else {
      return const LoginScreen();
    }
  }
}
