import 'package:flutter/material.dart';
import 'package:goipvc/ui/screens/login.dart';
import 'package:goipvc/ui/widgets/dropdown.dart';
import 'init_view.dart';

class FirstTimeScreen extends StatefulWidget {
  const FirstTimeScreen({super.key});

  @override
  State<FirstTimeScreen> createState() => FirstTimeScreenState();
}

class FirstTimeScreenState extends State<FirstTimeScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _acceptedTerms = false;

  void _handleConsentChange(bool? value) async {
    setState(() {
      _acceptedTerms = value ?? false;
    });
  }

  void _nextPage(BuildContext context) async {
    if (_currentPage < 2) {
      await _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentPage++);
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const InitView()),
      );
    }
  }

  void _previousPage() async {
    if (_currentPage > 0) {
      await _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentPage--);
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          ConsentPage(
            accepted: _acceptedTerms,
            onChanged: _handleConsentChange,
          ),
          ThemePage(),
          NotificationsPage()
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton(
              heroTag: "previousButton",
              elevation: 0,
              onPressed: _previousPage,
              child: const Icon(Icons.navigate_before),
            ),
            FloatingActionButton(
              heroTag: "nextButton",
              elevation: 0,
              foregroundColor: (!_acceptedTerms)
                  ? Theme.of(context).colorScheme.onSurface
                  : Theme.of(context).colorScheme.onPrimary,
              backgroundColor: (!_acceptedTerms)
                  ? Theme.of(context).colorScheme.surfaceContainerHighest
                  : Theme.of(context).colorScheme.primary,
              onPressed: (!_acceptedTerms) ? null : () => _nextPage(context),
              child: _currentPage == 2
                  ? const Icon(Icons.done)
                  : const Icon(Icons.navigate_next),
            ),
          ],
        ),
      ),
    );
  }
}

class ConsentPage extends StatelessWidget {
  final bool accepted;
  final ValueChanged<bool?> onChanged;

  const ConsentPage({
    super.key,
    required this.accepted,
    required this.onChanged,
  });

  String generateLoremIpsum({int paragraphs = 1}) {
    const loremIpsumText =
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";

    return List.filled(paragraphs, loremIpsumText).join('\n\n');
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Terms of Service & Privacy Policy",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      "Terms of Service",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  Text(
                    generateLoremIpsum(paragraphs: 3),
                  ),
                  SizedBox(height: 35),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      "Privacy Policy",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  Text(
                    generateLoremIpsum(paragraphs: 3),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16.0),
          CheckboxListTile(
            title: Text(
                "I have read and agree to the Terms of Service and Privacy Policy"),
            value: accepted,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class ThemePage extends StatelessWidget {
  const ThemePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Aparência",
                style: Theme.of(context).textTheme.headlineSmall,
              )),
          ListTile(
            leading: Icon(Icons.brightness_medium),
            title: Text("Tema"),
            trailing: Dropdown<String>(
              value: "system",
              items: [
                DropdownMenuItem<String>(
                  value: "system",
                  child: Text("Sistema"),
                ),
                DropdownMenuItem<String>(
                  value: "dark",
                  child: Text("Escuro"),
                ),
                DropdownMenuItem<String>(
                  value: "light",
                  child: Text("Claro"),
                ),
              ],
              onChanged: (String? value) {},
            ),
          ),
        ],
      ),
    );
  }
}

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Notificações",
                style: Theme.of(context).textTheme.headlineSmall,
              )),
          SwitchListTile(
            secondary: const Icon(Icons.notifications_on),
            title: Text("Notificações"),
            value: true,
            onChanged: (value) {},
          ),
        ],
      ),
    );
  }
}
