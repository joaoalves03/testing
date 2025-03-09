import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_markdown/flutter_markdown.dart';

class TermsScreen extends StatefulWidget {
  const TermsScreen({super.key});

  @override
  TermsScreenState createState() => TermsScreenState();
}

class TermsScreenState extends State<TermsScreen> {
  String _termsOfService = '';

  @override
  void initState() {
    super.initState();
    _loadTermsOfService();
  }

  Future<void> _loadTermsOfService() async {
    final String termsOfService = await rootBundle.loadString('assets/tos.md');
    setState(() {
      _termsOfService = termsOfService;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Termos de serviço"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: _termsOfService.isEmpty
            ? Center(child: CircularProgressIndicator())
            : Markdown(data: _termsOfService),
      ),
    );
  }
}
