import 'package:flutter/material.dart';
import 'package:goipvc/models/lesson.dart';
import 'package:goipvc/utils/globals.dart';
import 'package:intl/intl.dart';

void showLessonBottomSheet(BuildContext context, Lesson lesson) {
  String day = DateFormat.EEEE('pt').format(DateTime.parse(lesson.start));
  String startHour = DateFormat.Hm().format(DateTime.parse(lesson.start));
  String endHour = DateFormat.Hm().format(DateTime.parse(lesson.end));

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (context) {
      return Padding(
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
              leading: Icon(Icons.event),
              title: Text(
                lesson.className,
                style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.onSurface),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        toBeginningOfSentenceCase(day),
                        style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.onSurface),
                      ),
                      Dot(),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(text: startHour),
                            WidgetSpan(
                                child: Icon(Icons.arrow_forward_rounded, size: 16)),
                            TextSpan(text: endHour),
                          ],
                        ),
                        style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.onSurface
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        lesson.classType,
                        style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.onSurfaceVariant),
                      ),
                      Dot(textColor: Theme.of(context).colorScheme.onSurfaceVariant),
                      Text(
                        Lesson.getStatusFromColor(lesson.statusColor),
                        style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.onSurfaceVariant),
                      ),
                    ],
                  )
                ],
              ),
              isThreeLine: true,
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.place),
              title: Text(lesson.room),
            ),
            Divider(),
            if (lesson.teachers.isNotEmpty) ...[
              ...lesson.teachers.asMap().entries.map((entry) {
                final index = entry.key;
                final teacher = entry.value;

                return ListTile(
                  leading: index == 0
                      ? lesson.teachers.length > 1
                          ? Icon(Icons.people)
                          : Icon(Icons.person)
                      : Icon(null),
                  title: Text(
                    teacher,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () {},
                );
              }),
            ],
            Divider(),
            ListTile(
              leading: Icon(Icons.book),
              title: Text(
                "Ver cadeira",
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onSurface),
              ),
              trailing: Icon(Icons.chevron_right),
              onTap: () {},
            ),
          ],
        ),
      );
    },
  );
}
