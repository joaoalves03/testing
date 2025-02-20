import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:goipvc/providers/data_providers.dart';
import 'package:goipvc/ui/widgets/home/classes.dart';
import 'package:goipvc/ui/widgets/home/tasks.dart';
import 'package:goipvc/ui/widgets/home/meals.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(studentImageProvider);
  }

  @override
  Widget build(BuildContext context) {
    final firstNameAsync = ref.watch(firstNameProvider);
    final balanceAsync = ref.watch(balanceProvider);

    final firstName = firstNameAsync.value ?? 'utilizador';
    final balance = balanceAsync.value ?? 0.00;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Greeting(
              title: 'Olá $firstName!',
              slogan: 'O teu ● de partida',
              money: '$balance €',
              subtitle: 'Saldo atual',
            ),
            TabBar(
              unselectedLabelColor: Theme.of(context).colorScheme.onSurfaceVariant,
              tabs: [
                Tab(
                    icon: Icon(Icons.watch_later),
                    text: 'Aulas'
                ),
                Tab(
                    icon: Icon(Icons.task),
                    text: 'Tarefas'
                ),
                Tab(
                    icon: Icon(Icons.local_dining),
                    text: 'Ementas'
                ),
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
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
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
                      color: Theme.of(context).colorScheme.primary,
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
              height: 20,
            ),
          ),
        ],
      ),
    );
  }
}
