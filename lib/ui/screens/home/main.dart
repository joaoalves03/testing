import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import './classes.dart';
import './tasks.dart';
import './meals.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  late SharedPreferences prefs;
  late String serverUrl, academicosToken, sasToken, sasRefreshToken;

  @override
  void initState() {
    super.initState();
    _initializePreferences();
  }

  Future<void> _initializePreferences() async {
    prefs = await SharedPreferences.getInstance();
    serverUrl = prefs.getString('server_url')!;
    academicosToken = prefs.getString('academicos_token')!;
    sasToken = prefs.getString('sas_token')!;
    sasRefreshToken = prefs.getString('sas_refresh_token')!;

    _fetchName();
    _getBalance();
  }

  String name = '';
  Future<void> _fetchName() async {
    final response = await http.get(
      Uri.parse('$serverUrl/academicos/student-info'),
      headers: {
        'Cookie': academicosToken,
      },
    );
    if (response.statusCode == 200) {
      setState(() {
        var jsonResponse = jsonDecode(response.body);
        name = jsonResponse['name'].split(' ')[0];
      });
    }
  }

  double balance = 0.00;
  Future<void> _getBalance() async {
    final response = await http.get(
      Uri.parse('$serverUrl/sas/balance'),
      headers: {
        'Authorization': sasToken,
        'Cookie': sasRefreshToken,
      },
    );
    if (response.statusCode == 200) {
      setState(() {
        balance = double.parse(response.body);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Greeting(
              title: 'Olá $name!',
              slogan: 'O teu ● de partida',
              money: '${balance.toString().replaceAll('.', ',')} €',
              subtitle: 'Saldo atual',
            ),
            TabBar(
              tabs: [
                Tab(icon: Icon(Icons.watch_later), text: 'Aulas'),
                Tab(icon: Icon(Icons.task), text: 'Tarefas'),
                Tab(icon: Icon(Icons.local_dining), text: 'Ementas'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  ClassesTab(),
                  TasksTab(),
                  MealsTab(),
                ],
              ),
            ),
          ],
        ),
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
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                      color: Theme.of(context).primaryColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    slogan,
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
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: SvgPicture.asset(
              'assets/divider.svg',
              height: 32,
            ),
          ),
        ],
      ),
    );
  }
}
