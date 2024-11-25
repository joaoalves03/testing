import 'package:flutter/material.dart';

import '../widgets/header.dart';

void main() => runApp(HomeScreen());

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
          flexibleSpace: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Header(),
            ),
          ),
          bottom: TabBar(
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
      ),
    );
  }
}
