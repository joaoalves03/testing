import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:goipvc/utils/globals.dart';
import 'package:goipvc/models/task.dart';
import 'package:goipvc/ui/screens/menu/curricular_unit.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dot.dart';

void showTaskBottomSheet(BuildContext context, Task task) {
  String day = DateFormat("EEEE, dd-MM-yyyy").format(DateTime.parse(task.due));
  String dueHour = formatTimeToHours(task.due);

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (context) {
      return SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            SizedBox(height: 16),
            ListTile(
              leading: Icon(task.overdue
                  ? Icons.cancel_schedule_send
                  : Icons.schedule_send),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if(task.overdue)
                    Text(
                      "Overdue",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                        fontSize: 12,
                      ),
                    ),
                  Text(
                    task.title,
                    style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.onSurface),
                  )
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        dueHour,
                        style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.onSurface),
                      ),
                      Dot(),
                      Text(
                        toBeginningOfSentenceCase(day),
                        style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.onSurface),
                      ),
                    ],
                  ),
                ],
              ),
              isThreeLine: true,
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.book),
              title: Text(
                "Ver Unidade Curricular",
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onSurface),
              ),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CurricularUnitScreen(
                              curricularUnitId: task.curricularUnitId,
                            )));
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.task),
              title: Text(
                task.overdue
                    ? "Ver Tarefa"
                    : "Submeter",
                style:
                TextStyle(color: Theme.of(context).colorScheme.onSurface),
              ),
              trailing: Icon(Icons.chevron_right),
              onTap: () async {
                final webUrl = Uri.parse(task.overdue
                    ? task.url
                    : task.submissionURL);

                try {
                  await launchUrl(webUrl);
                } catch (e) {
                  throw 'Could not launch $webUrl';
                }
              },
            ),
          ],
        ),
      ));
    },
  );
}
