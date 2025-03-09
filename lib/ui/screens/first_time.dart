import 'package:flutter/material.dart';
import 'package:goipvc/ui/screens/login.dart';
import 'package:goipvc/ui/widgets/dropdown.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:permission_handler/permission_handler.dart';
import '../init_view.dart';

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
        padding: const EdgeInsets.symmetric(horizontal: 16),
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
            leading: const Icon(Icons.brightness_medium),
            title: const Text("Tema"),
            trailing: Dropdown<String>(
              value: "system",
              items: const [
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

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  NotificationsPageState createState() => NotificationsPageState();
}

class NotificationsPageState extends State<NotificationsPage> {
  bool _notificationsEnabled = false;
  bool _isRequestingPermission = false;
  int _deniedCount = 0;

  Future<void> _requestNotificationPermission() async {
    if (_isRequestingPermission) return;
    setState(() => _isRequestingPermission = true);

    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    void showPermissionDialog() {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Permissão para Notificações"),
          content: const Text(
              "A aplicação não conseguiu pedir permissões automaticamente. Para ativar as notificações, é preciso permitir nas configurações do Android."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                openAppSettings();
              },
              child: const Text("Abrir Configurações"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancelar"),
            ),
          ],
        ),
      );
    }

    setState(() {
      _isRequestingPermission = false;
      switch (settings.authorizationStatus) {
        case AuthorizationStatus.authorized:
        case AuthorizationStatus.provisional:
          _notificationsEnabled = true;
          break;
        case AuthorizationStatus.denied:
          _notificationsEnabled = false;
          _deniedCount++;
          if (_deniedCount > 2) {
            showPermissionDialog();
          }
          break;
        case AuthorizationStatus.notDetermined:
          break;
      }
    });
  }

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
            ),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.notifications_on),
            title: const Text("Notificações"),
            value: _notificationsEnabled,
            onChanged: _isRequestingPermission
                ? null
                : (value) async {
                    if (value) {
                      await _requestNotificationPermission();
                    } else {
                      await FirebaseMessaging.instance.deleteToken();
                      setState(() => _notificationsEnabled = false);
                    }
                  },
          ),
        ],
      ),
    );
  }
}
