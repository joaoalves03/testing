import 'package:flutter/material.dart';
import 'package:goipvc/models/lesson.dart';

void showLessonBottomSheet(BuildContext context, Lesson lesson) {
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
                    color: Theme.of(context).colorScheme.onSurface
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Quinta",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant
                    ),
                  ),
                  Text(
                    "${lesson.start} → ${lesson.end}",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface
                    ),
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
            if (lesson.teachers.isNotEmpty)
              ListTile(
                leading: Icon(Icons.person),
                title: Text(
                  lesson.teachers.join(", "),
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface
                  ),
                ),
                trailing: Icon(Icons.chevron_right),
                onTap: () {

                },
              ),
            Divider(),
            ListTile(
              leading: Icon(Icons.book),
              title: Text(
                "Ver cadeira",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface
                ),
              ),
              trailing: Icon(Icons.chevron_right),
              onTap: () {

              },
            ),
          ],
        ),
      );
    },
  );
}