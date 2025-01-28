import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import '../../generated/l10n.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _serverController =
      TextEditingController(text: 'https://api.goipvc.xyz');
  final FocusNode _serverFocusNode = FocusNode();
  Color _serverBorderColor = Colors.grey;

  Future<void> _login() async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;
    final String serverUrl = _serverController.text;

    String? errorMessage;

    try {
      final response = await http
          .post(
            Uri.parse('$serverUrl/login'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{
              'username': username,
              'password': password,
            }),
          )
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('serverUrl', serverUrl);

        if (mounted) {
          Navigator.pushReplacementNamed(context, '/home');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(Icons.storage),
                SizedBox(width: 8.0),
                Text('Server:'),
                SizedBox(width: 8.0),
                Expanded(
                  child: TextField(
                    controller: _serverController,
                    focusNode: _serverFocusNode,
                    decoration: InputDecoration(
                      hintText: 'https://api.goipvc.xyz/',
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: _serverBorderColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: _serverBorderColor),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: _pingServer,
                  child: Text('Test'),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: S.of(context).username),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: S.of(context).password),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: _login,
              child: Text(S.of(context).login),
            ),
          ],
        ),
      ),
    );
  }
}
