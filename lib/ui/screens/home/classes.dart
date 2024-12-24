import 'package:flutter/material.dart';
import 'package:goipvc/models/lesson.dart';
import 'package:goipvc/ui/widgets/home/date_section.dart';
import 'package:goipvc/ui/widgets/card.dart';

class ClassesTab extends StatefulWidget {
  const ClassesTab({super.key});

  @override
  ClassesTabState createState() => ClassesTabState();
}

class ClassesTabState extends State<ClassesTab> {
  final List<Lesson> lessons = [
    Lesson(
      shortName: "SO",
      className: "Sistemas Operativos",
      classType: "PL",
      start: "09:00",
      end: "10:00",
      id: "1",
      teachers: ["Vitor Ferreira"],
      room: "S2.1",
      statusColor: "#FF0000",
    ),
    Lesson(
      shortName: "BD",
      className: "Bases de Dados",
      classType: "TP",
      start: "10:00",
      end: "12:00",
      id: "2",
      teachers: ["Ana Oliveira"],
      room: "S3.2",
      statusColor: "#00FF00",
    ),
    Lesson(
      shortName: "AED",
      className: "Algoritmos e Estruturas de Dados",
      classType: "TP",
      start: "08:00",
      end: "09:30",
      id: "3",
      teachers: ["Carlos Costa"],
      room: "A1.1",
      statusColor: "#0000FF",
    ),
    Lesson(
      shortName: "PDI",
      className: "Processamento Digital de Imagem",
      classType: "PL",
      start: "16:30",
      end: "18:30",
      id: "4",
      teachers: ["Joana Martins"],
      room: "L4.2",
      statusColor: "#FFA500",
    ),
  ];

  DateTime now = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day
  );


  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: () async {

        },
        child: ListView.builder(
            itemCount: 7,
            itemBuilder: (context, index) {
              DateTime currentDate = now.add(Duration(days: index));

              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  child: Column(
                    children: [
                      DateSection(date: currentDate),

                      RightNowCard(lesson: lessons[0]),
                      NextClasses(
                        children: [
                          UpcomingClass(lesson: lessons[0], extend: true),

                          ...lessons
                              .skip(1)
                              .map((lesson) => UpcomingClass(lesson: lesson))
                        ],
                      )
                    ],
                  ),
                );
              }

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                child: Column(
                    children: [
                      DateSection(date: currentDate),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                        child: Column(
                          children: lessons
                              .map((lesson) => UpcomingClass(lesson: lesson))
                              .toList(),
                        ),
                      )
                    ]
                )
              );
            },
        )
    );
  }
}

class RightNowCard extends StatelessWidget {
  final Lesson lesson;

  const RightNowCard({
    super.key,
    required this.lesson,
  });

  @override
  Widget build(BuildContext context) {
    return FilledCard(
        children: [
          _buildTitleRow(context),
          _buildInfoRow(),
          _buildProgressRow(),
        ],
    );
  }

  Row _buildTitleRow(BuildContext context) {
    return Row(
      children: [
        Text(lesson.classType, style: TextStyle(fontWeight: FontWeight.w900)),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 1),
          child: Text(' • ', style: TextStyle(fontSize: 22)),
        ),
        Text(
          lesson.className,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
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
        Text(lesson.teachers[0], style: const TextStyle(fontSize: 13)),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: Text(' • '),
        ),
        Text(lesson.room, style: const TextStyle(fontSize: 13)),
      ],
    );
  }

  Row _buildProgressRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(lesson.start),
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
        Text(lesson.end),
      ],
    );
  }
}

class NextClasses extends StatelessWidget {
  final List<Widget> children;

  const NextClasses({super.key, required this.children,});

  @override
  Widget build(BuildContext context) {
    return FilledCard(
      icon: Icons.browse_gallery,
      title: 'Próximas Aulas',
      children: children,
    );
  }
}

class UpcomingClass extends StatelessWidget {
  final Lesson lesson;
  final bool extend;

  const UpcomingClass({
    super.key,
    required this.lesson,
    this.extend = false,
  });

  Widget _buildDot() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: Text('•', style: TextStyle(fontSize: 22)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            if (!extend) Text(lesson.start),
            if (!extend) _buildDot(),
            Text(lesson.classType),
            _buildDot(),
            Text(
              lesson.className,
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
          ],
        ),
        if (extend)
          Padding(
            padding: EdgeInsets.only(left: 22),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.watch_later, size: 16),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(text: lesson.start),
                          const WidgetSpan(
                              child: Icon(Icons.arrow_forward_rounded, size: 16)
                          ),
                          TextSpan(text: lesson.end),
                        ],
                      ),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16),
                    Text(lesson.room),
                  ],
                ),
              ],
            ),
          )
        ],
    );
  }
}