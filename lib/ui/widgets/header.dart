import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:goipvc/ui/screens/notifications.dart';

class Header extends StatefulWidget implements PreferredSizeWidget {
  const Header({super.key});

  @override
  HeaderState createState() => HeaderState();

  // Add preferredSize getter
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class HeaderState extends State<Header> {
  @override
  void initState() {
    super.initState();
    _loadImagePath();
  }

  String imagePath = 'assets/logos/IPVC.svg';

  Future<void> _loadImagePath() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String layout = prefs.getString('layout') ?? 'IPVC';
    setState(() {
      imagePath = layout == 'IPVC'
          ? 'assets/logos/IPVC.svg'
          : 'assets/logos/$layout.svg';
    });
  }

  void _openNotificationScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NotificationsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      surfaceTintColor: Theme.of(context).colorScheme.surface,
      title: SvgPicture.asset(
        imagePath,
        height: 32,
      ),
      actions: [
        IconButton(
          onPressed: () => _openNotificationScreen(context),
          icon: const Icon(Icons.notifications_none, size: 28),
        ),
      ],
    );
  }
}
