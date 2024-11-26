import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../themes.dart';
import '../widgets/header.dart';
import '../widgets/navbar.dart';

void main() => runApp(HomeScreen());

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: esaTheme['light'],
      darkTheme: esaTheme['dark'],
      themeMode: ThemeMode.system,
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          toolbarHeight: 135,
          flexibleSpace: SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Header(),
                  Greeting(
                    title: 'Olá Matt!',
                    slogan: 'O teu ● de partida',
                    money: '0,00 €',
                    subtitle: 'Saldo atual',
                  ),
                ],
              ),
            ),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.schedule), text: 'Aulas'),
              Tab(icon: Icon(Icons.task), text: 'Tarefas'),
              Tab(icon: Icon(Icons.local_dining), text: 'Ementas'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Center(child: Text('Aulas')),
            Center(child: Text('Tarefas')),
            Center(child: Text('Ementas')),
          ],
        ),
        bottomNavigationBar: Navbar(),
      ),
    );
  }
}

class Greeting extends StatelessWidget {
  final String title;
  final String slogan;
  final String money;
  final String subtitle;

  const Greeting({
    super.key,
    required this.title,
    required this.slogan,
    required this.money,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Text(
                    slogan,
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    money,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: SvgPicture.asset(
              "assets/divider.svg",
              height: 32,
            ),
          ),
        ],
      ),
    );
  }
}
