import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_markdown/flutter_markdown.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  PrivacyScreenState createState() => PrivacyScreenState();
}

class PrivacyScreenState extends State<PrivacyScreen> {
  String _privacyPolicy = '';

  @override
  void initState() {
    super.initState();
    _loadPrivacyPolicy();
  }

  Future<void> _loadPrivacyPolicy() async {
    final String privacyPolicy = await rootBundle.loadString('assets/pp.md');
    setState(() {
      _privacyPolicy = privacyPolicy;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Política de privacidade"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: _privacyPolicy.isEmpty
            ? Center(child: CircularProgressIndicator())
            : Markdown(data: _privacyPolicy),
      ),
    );
  }
}
