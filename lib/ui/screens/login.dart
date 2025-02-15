import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:goipvc/generated/l10n.dart';
import 'package:goipvc/ui/widgets/containers.dart';
import '../init_view.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _serverController = TextEditingController();
  final FocusNode _serverFocusNode = FocusNode();
  Color _serverBorderColor = Colors.grey;

  @override
  void initState() {
    super.initState();
    _loadServerUrl();
  }

  Future<void> _loadServerUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedServerUrl = prefs.getString('server_url');
    _serverController.text = savedServerUrl ?? 'https://api.goipvc.xyz';
  }

  Future<void> _login() async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;
    final String serverUrl = _serverController.text;

    String? errorMessage;

    try {
      final response = await http
          .post(
            Uri.parse('$serverUrl/auth/login'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{
              'username': username,
              'password': password,
            }),
          )
          .timeout(const Duration(seconds: 6));

      if (response.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('server_url', serverUrl);
        await prefs.setBool('is_logged_in', true);
        await prefs.setString('username', username);
        await prefs.setString('password', password);

        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        final Map<String, dynamic> tokens = responseBody['tokens'];
        await prefs.setString('academicos_token', tokens['academicos']);
        await prefs.setString('on_token', tokens['on']);
        await prefs.setString('sas_token', tokens['sas']);
        await prefs.setString('sas_refresh_token', tokens['sasRefresh']);

        if (mounted) {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) {
                return InitView();
              },

              //Transition
              transitionDuration: const Duration(milliseconds: 500),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return SharedAxisTransition(
                  animation: animation,
                  secondaryAnimation: secondaryAnimation,
                  transitionType: SharedAxisTransitionType.vertical,
                  child: child,
                );
              },
            ),
          );
        }
      } else {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        errorMessage = responseBody['error'] ?? 'Login failed';
      }
    } on http.ClientException catch (e) {
      errorMessage = e.message;
    } on TimeoutException catch (_) {
      errorMessage = 'Request timed out';
    }

    if (mounted && errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
        ),
      );
    }
  }

  Future<void> _pingServer() async {
    final String serverUrl = _serverController.text;

    try {
      final response = await http
          .get(Uri.parse(serverUrl))
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        setState(() {
          _serverBorderColor = Colors.green;
        });
      }
    } catch (e) {
      setState(() {
        _serverBorderColor = Colors.red;
      });
    }
  }

  void _showServerSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _serverController,
                focusNode: _serverFocusNode,
                decoration: InputDecoration(
                  labelText: "Server:",
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: _serverBorderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: _serverBorderColor),
                  ),
                ),
                autocorrect: false,
              ),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: _pingServer,
                  child: Text("Test"),
                ),
                TextButton(
                    onPressed: () {
                      setState(() {});
                      Navigator.pop(context);
                    },
                    child: Text("Save")
                ),
              ],
            )
          ],
        );
      },
    );
  }

  void _showQuickSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.all(4),
          title: Text("Settings"),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ListTile(
                  leading: const Icon(Icons.dns),
                  title: const Text("Server"),
                  trailing: ValueListenableBuilder<TextEditingValue>(
                    valueListenable: _serverController,
                    builder: (context, value, child) {
                      return TextContainer(text: value.text);
                    },
                  ),
                  onTap: () {
                    _showServerSettings(context);
                  },
                )
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Close")
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              _showQuickSettings(context);
            },
            icon: const Icon(Icons.settings),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset(
              'assets/logo.svg',
              height: 64,
              colorFilter: ColorFilter.mode(
                Theme.of(context).colorScheme.onSurface,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            AutofillGroup(
              child: Column(
                children: [
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: S.of(context).username
                    ),
                    autofillHints: const [AutofillHints.username],
                    autocorrect: false,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: S.of(context).password
                    ),
                    obscureText: true,
                    autofillHints: const [AutofillHints.password],
                    autocorrect: false,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            FilledButton.icon(
              onPressed: _login,
              label: Text("Login"),
              icon: const Icon(Icons.login),
            ),
          ],
        ),
      )
    );
  }
}