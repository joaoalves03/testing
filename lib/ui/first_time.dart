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
  final List<Widget> pages = [ThemePage(), NotificationsPage()];

  void _nextPage(BuildContext context) async {
    if (_currentPage < pages.length - 1) {
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
        children: pages,
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
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              backgroundColor: Theme.of(context).colorScheme.primary,
              onPressed: () => _nextPage(context),
              child: _currentPage == pages.length - 1
                  ? const Icon(Icons.done)
                  : const Icon(Icons.navigate_next),
            ),
          ],
        ),
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
