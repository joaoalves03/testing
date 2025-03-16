import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goipvc/utils/globals.dart';
import 'package:goipvc/providers/data_providers.dart';

import 'package:goipvc/models/curricular_unit.dart';
import 'package:goipvc/models/task.dart';
import 'package:goipvc/ui/screens/schedule.dart';

import 'package:goipvc/ui/widgets/card.dart';
import 'package:goipvc/ui/widgets/error_message.dart';

class GeneralTab extends ConsumerWidget {
  final CurricularUnit curricularUnit;

  const GeneralTab({
    super.key,
    required this.curricularUnit
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(curricularUnitProvider);
        ref.invalidate(tasksProvider);
      },
      child: ListView(
        padding: EdgeInsets.all(10),
        children: [
          Column(
            children: [
              ScheduleWidget(curricularUnit: curricularUnit),
              TeachersWidget(curricularUnit: curricularUnit),
              TasksWidget(curricularUnit: curricularUnit),
            ],
          ),
        ]
      ),
    );
  }
}

class ScheduleWidget extends ConsumerWidget {
  final CurricularUnit curricularUnit;

  const ScheduleWidget({
    super.key,
    required this.curricularUnit,
  });

  Future<SharedPreferences> _getPrefs() async {
    return await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lessonsAsync = ref.watch(lessonsProvider);

    return FutureBuilder<SharedPreferences>(
      future: _getPrefs(),
      builder: (context, prefsSnapshot) {
        if (prefsSnapshot.connectionState != ConnectionState.done) {
          return FilledCard(
            icon: Icons.watch_later,
            title: "Horário",
            children: [
              Center(child: CircularProgressIndicator())
            ],
          );
        }

        final prefs = prefsSnapshot.data!;

        return lessonsAsync.when(
          data: (lessons) {
            final length = prefs.getString("calendar_view") == "workWeek"
                ? 5
                : 7;
            final now = DateTime.now();

            final currentWeekStart = DateTime(now.year, now.month, now.day)
                .subtract(Duration(days: now.weekday - 1));
            final currentWeekEnd = currentWeekStart.add(Duration(days: 7));

            final currentWeekLessons = lessons.where((lesson) {
              final lessonDate = DateTime.parse(lesson.start);
              return lessonDate.isAfter(currentWeekStart) &&
                  lessonDate.isBefore(currentWeekEnd) &&
                  lesson.curricularUnitId == curricularUnit.id;
            }).toList();

            final activeDays = List.generate(7, (index) {
              final day = index + 1;
              return currentWeekLessons.any((lesson) {
                final lessonDate = DateTime.parse(lesson.start);
                return lessonDate.weekday == day;
              });
            });

            if (activeDays.every((isActive) => !isActive)) {
              return SizedBox.shrink();
            }

            return FilledCard(
              icon: Icons.watch_later,
              title: "Horário",
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(length, (index) {
                      final day = index;
                      return DayCircle(
                        day: day,
                        active: activeDays[index],
                      );
                    }),
                  ),
                ),
                Divider(),
                SizedBox(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) =>
                              Scaffold(
                                appBar: AppBar(
                                  title: Text("Horário"),
                                ),
                                body: ScheduleScreen(),
                              )
                          )
                      );
                    },
                    child: Row(
                      children: [
                        Icon(Icons.arrow_forward),
                        SizedBox(width: 6),
                        Text("Ver Horário")
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
          loading: () => Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => ErrorMessage(
            error: error.toString(),
            stackTrace: stackTrace.toString(),
            callback: () async {
              ref.invalidate(curricularUnitProvider);
            },
          ),
        );
      },
    );
  }
}

class DayCircle extends StatelessWidget {
  final int day;
  final bool active;

  const DayCircle({
    super.key,
    required this.day,
    required this.active
  });

  @override
  Widget build(BuildContext context) {
    List<String> dayLetter = ["S", "T", "Q", "Q", "S", "S", "D"];

    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active
            ? Theme.of(context).colorScheme.primaryContainer
            : Theme.of(context).colorScheme.surfaceContainer,
      ),
      child: Center(
        child: Text(
          dayLetter[day],
          style: TextStyle(
            color: active
                ? Theme.of(context).colorScheme.onPrimaryContainer
                : Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}

class TeachersWidget extends ConsumerStatefulWidget {
  final CurricularUnit curricularUnit;

  const TeachersWidget({
    super.key,
    required this.curricularUnit,
  });

  @override
  ConsumerState<TeachersWidget> createState() => _TeachersWidgetState();
}

class _TeachersWidgetState extends ConsumerState<TeachersWidget> {
  bool _showAllTeachers = false;

  @override
  Widget build(BuildContext context) {
    final otherTeachers = widget.curricularUnit.puc?.otherTeachers ?? [];
    final totalOtherTeachers = otherTeachers.length;
    final visibleOtherTeachers = _showAllTeachers ? otherTeachers : otherTeachers.take(2).toList();
    final remainingTeachersCount = totalOtherTeachers - visibleOtherTeachers.length;

    return FilledCard(
      icon: Icons.design_services,
      title: "Docentes",
      children: [
        ...?widget.curricularUnit.puc?.responsible.map((teacher) {
          return ListTile(
            visualDensity: VisualDensity.compact,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Responsável',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  teacher?.name ?? 'Desconhecido',
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            subtitle: Text(teacher?.email ?? 'Sem Email'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {},
          );
        }),

        ...visibleOtherTeachers.map((teacher) {
          return ListTile(
            visualDensity: VisualDensity.compact,
            title: Text(
              teacher?.name ?? 'Desconhecido',
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(teacher?.email ?? 'Sem email'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {},
          );
        }),

        if (remainingTeachersCount > 0 && !_showAllTeachers)
          Center(
            child: TextButton(
              onPressed: () {
                setState(() {
                  _showAllTeachers = true;
                });
              },
              child: Text(
                'Ver +$remainingTeachersCount docentes',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),

        if (_showAllTeachers)
          Center(
            child: TextButton(
              onPressed: () {
                setState(() {
                  _showAllTeachers = false;
                });
              },
              child: Text(
                'Mostrar menos',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),

      ],
    );
  }
}

class TasksWidget extends ConsumerWidget {
  final CurricularUnit curricularUnit;

  const TasksWidget({
    super.key,
    required this.curricularUnit,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(tasksProvider);

    return FilledCard(
      icon: Icons.book,
      title: "Tarefas",
      children: [
        tasksAsync.when(
          data: (tasks) {
            final now = DateTime.now();

            final upcomingTasks = tasks.where((task) {
              final taskDue = DateTime.parse(task.due);
              return task.curricularUnitId == curricularUnit.id && taskDue.isAfter(now);
            }).toList();

            upcomingTasks.sort((a, b) =>
                DateTime.parse(a.due).compareTo(DateTime.parse(b.due)));

            final groupedTasks = <String, List<Task>>{};
            for (var task in upcomingTasks) {
              final taskDate =
              DateFormat('yyyy-MM-dd').format(DateTime.parse(task.due));
              groupedTasks.putIfAbsent(taskDate, () => []).add(task);
            }

            if(upcomingTasks.isEmpty){
              return ErrorMessage(
                message: "Sem tarefas por fazer",
                size: 14,
              );
            }

            return Column(
              children: [
                SizedBox(height: 10),
                ...groupedTasks.entries.map((entry) {
                  final dateString = entry.key;
                  final tasksForDay = entry.value;

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DateSection(
                        date: DateTime.parse(dateString),
                      ),

                      ...tasksForDay.map((task) => UpcomingTask(task: task)),
                      SizedBox(height: 15),
                    ],
                  );
                })
              ]
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, stackTrace) => ErrorMessage(
              error: error.toString(),
              stackTrace: stackTrace.toString(),
              callback: () {
                ref.invalidate(tasksProvider);
              }),
        )
      ],
    );
  }
}

class DateSection extends StatelessWidget {
  final DateTime date;

  const DateSection({
    super.key,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    String day;

    if (date.difference(today).inDays == 0) {
      day = "Hoje";
    } else if (date.difference(today).inDays == 1) {
      day = "Amanhã";
    } else {
      day = DateFormat("EEEE, dd MMMM yyyy", 'pt').format(date);
    }

    return Row(
      children: [
        Text(
          toBeginningOfSentenceCase(day),
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary
          ),
        )
      ],
    );
  }
}

class UpcomingTask extends StatelessWidget{
  final Task task;

  const UpcomingTask({
    super.key,
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final webUrl = Uri.parse(task.url);

        try {
          await launchUrl(webUrl);
        } catch (e) {
          throw 'Could not launch $webUrl';
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6),
        child: Row(
          children: [
            Text(
                formatTimeToHours(task.due)
            ),
            SizedBox(width: 4),
            Icon(task.icon),
            SizedBox(width: 4),
            Expanded(
              child: Text(
                task.title,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            SizedBox(width: 10),
            Icon(Icons.arrow_forward),
          ],
        ),
      ),
    );
  }
}
