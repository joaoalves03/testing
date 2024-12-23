import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../widgets/header.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
        body: const TabBarView(
          children: [
            ClassesTab(),
            Center(child: Text('Tarefas')),
            Center(child: Text('Ementas')),
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

Color surfaceContainerColor(BuildContext context) {
  return Theme.of(context).primaryColor.withOpacity(0.1);
} // @TODO: learn a better way to do this

class ClassesTab extends StatefulWidget {
  const ClassesTab({super.key});

  @override
  ClassesTabState createState() => ClassesTabState();
}

class ClassesTabState extends State<ClassesTab> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          const ActiveClassCard(
            title: 'Sistemas Operativos',
            teacher: 'Prof. António Cruz',
            room: 'Sala 2.1',
            startTime: '14:00',
            endTime: '16:00',
          ),
          const SizedBox(height: 12),
          const NextClasses(first: true),
          const SizedBox(height: 12),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 5,
            itemBuilder: (context, index) => const NextClasses(),
            separatorBuilder: (context, index) => const SizedBox(height: 12),
          ),
        ],
      ),
    );
  }
}

class ActiveClassCard extends StatelessWidget {
  final String title;
  final String teacher;
  final String room;
  final String startTime;
  final String endTime;

  const ActiveClassCard({
    super.key,
    required this.title,
    required this.teacher,
    required this.room,
    required this.startTime,
    required this.endTime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: surfaceContainerColor(context),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitleRow(context),
          _buildInfoRow(),
          const SizedBox(height: 8),
          _buildProgressRow(),
        ],
      ),
    );
  }

  Row _buildTitleRow(BuildContext context) {
    return Row(
      children: [
        const Text('PL', style: TextStyle(fontWeight: FontWeight.w900)),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 1),
          child: Text(' • ', style: TextStyle(fontSize: 22)),
        ),
        Text(
          title,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }

  Row _buildInfoRow() {
    return Row(
      children: [
        Text(teacher, style: const TextStyle(fontSize: 13)),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: Text(' • '),
        ),
        Text(room, style: const TextStyle(fontSize: 13)),
      ],
    );
  }

  Row _buildProgressRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(startTime),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: const LinearProgressIndicator(
                value: 0.5,
                minHeight: 20,
              ),
            ),
          ),
        ),
        Text(endTime),
      ],
    );
  }
}

class NextClasses extends StatelessWidget {
  final bool first;

  const NextClasses({super.key, this.first = false});

  Row _buildHeader(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.event_note,
          color: Theme.of(context).primaryColor,
          size: 20,
        ),
        const SizedBox(width: 4),
        Text(
          'Próximas Aulas',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: first ? surfaceContainerColor(context) : null,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (first) _buildHeader(context),
          UpcomingClass(
            title: 'Inteligência Artificial',
            startTime: '16:00',
            endTime: '17:00',
            room: 'Sala 2.1',
            first: first,
          ),
          if (first) const SizedBox(height: 8),
          const UpcomingClass(
            title: 'Tecnologias Multimédia',
            startTime: '17:00',
            endTime: '18:00',
            room: 'Sala 2.1',
          ),
          const UpcomingClass(
            title: 'Tecnologias Multimédia',
            startTime: '18:00',
            endTime: '19:00',
            room: 'Sala 2.1',
          ),
        ],
      ),
    );
  }
}

class UpcomingClass extends StatelessWidget {
  final String title;
  final String startTime;
  final String endTime;
  final String room;
  final bool first;

  const UpcomingClass({
    super.key,
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.room,
    this.first = false,
  });

  Widget _buildDot() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: Text('•', style: TextStyle(fontSize: 22)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (!first) Text(startTime),
        if (!first) _buildDot(),
        const Text('PL'),
        _buildDot(),
        Text(
          title,
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        if (first)
          Row(
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.watch_later, size: 16),
                      Text('$startTime -> $endTime'),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16),
                      Text(room),
                    ],
                  ),
                ],
              ),
            ],
          )
      ],
    );
  }
}
