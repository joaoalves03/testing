import 'package:flutter/material.dart';
import 'package:goipvc/models/task.dart';
import 'package:goipvc/ui/widgets/home/date_section.dart';

class TasksTab extends StatefulWidget {
  const TasksTab({super.key});

  @override
  TasksTabState createState() => TasksTabState();
}

class TasksTabState extends State<TasksTab> {
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

            return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                child: Column(
                    children: [
                      DateSection(date: currentDate),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                        child: Column(
                          children: [
                            UpcomingTask(
                                task: Task(
                                    id: 1,
                                    title: "Tarefa 5",
                                    due: "22:59",
                                    className: "Admistração de Base de Dados",
                                    type: "Submission"
                                )
                            ),
                          ],
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

class UpcomingTask extends StatelessWidget{
  final Task task;

  const UpcomingTask({
    super.key,
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(task.due),
        SizedBox(width: 10),
        Icon(
          Icons.publish,
          size: 34,
          color: Theme.of(context).colorScheme.primary,
        ),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                task.title,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                )
            ),
            Text(task.className)
          ],
        )
      ],
    );
  }
  
}