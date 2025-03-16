import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goipvc/ui/widgets/task_sheet.dart';
import 'package:intl/intl.dart';
import 'package:goipvc/utils/globals.dart';
import 'package:goipvc/providers/data_providers.dart';
import 'package:goipvc/models/task.dart';

import 'package:goipvc/ui/widgets/error_message.dart';
import 'date_section.dart';

class TasksTab extends ConsumerWidget {
  const TasksTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(tasksProvider);

    return tasksAsync.when(
        data: (tasks) {
          final now = DateTime.now();

          final upcomingTasks = tasks.where((task) {
            final taskDue = DateTime.parse(task.due);
            return taskDue.isAfter(now);
          }).toList();

          upcomingTasks.sort((a, b) =>
              DateTime.parse(a.due).compareTo(DateTime.parse(b.due)));
          final displayedTasks = upcomingTasks.take(7).toList();

          final groupedTasks = <String, List<Task>>{};
          for (var task in displayedTasks) {
            final taskDate =
            DateFormat('yyyy-MM-dd').format(DateTime.parse(task.due));
            groupedTasks.putIfAbsent(taskDate, () => []).add(task);
          }
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(tasksProvider);
            },
            child: ListView.builder(
              itemCount: 7,
              itemBuilder: (context, index) {
                final currentDate = now.add(Duration(days: index));
                final date = DateFormat('yyyy-MM-dd').format(currentDate);
                final tasksForDate = groupedTasks[date] ?? [];

                if (currentDate != now || tasksForDate.isNotEmpty) {
                  return Padding(
                    padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    child: Column(
                      children: [
                        DateSection(
                          date: currentDate,
                          textColor: tasksForDate.isNotEmpty
                              ? null
                              : Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        if (tasksForDate.isNotEmpty) ...[
                          Column(
                            children: tasksForDate.map((task) {
                                return UpcomingTask(task: task);
                            }).toList()
                          ),
                        ],
                        SizedBox(height: 40)
                      ],
                    ),
                  );
                }
                return SizedBox.shrink();
              },
            ),
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
      onTap: () {
        showTaskBottomSheet(context, task);
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    task.curricularUnitName!,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  )
                ],
              )
            ),
          ],
        ),
      ),
    );
  }
}