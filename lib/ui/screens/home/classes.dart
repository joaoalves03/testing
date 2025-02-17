import 'package:flutter/material.dart';
import 'package:goipvc/ui/widgets/error_message.dart';
import 'package:intl/intl.dart';
import 'package:goipvc/models/lesson.dart';
import 'package:goipvc/services/data_provider.dart';
import 'package:goipvc/ui/widgets/home/date_section.dart';
import 'package:goipvc/ui/widgets/card.dart';
import 'package:goipvc/ui/widgets/lesson_sheet.dart';
import 'package:provider/provider.dart';

class ClassesTab extends StatefulWidget {
  const ClassesTab({super.key});

  @override
  ClassesTabState createState() => ClassesTabState();
}

class ClassesTabState extends State<ClassesTab> {
  @override
  void initState() {
    super.initState();
    _initializeAndFetchLessons();
  }

  void fetchLessons() {
    if (!mounted) return;
    Provider.of<DataProvider>(context, listen: false).fetchLessons();
  }

  void _initializeAndFetchLessons() async {
    await Provider.of<DataProvider>(context, listen: false)
        .initializePreferences();
    fetchLessons();
  }

  final now = DateTime.now();

  Widget _buildNowCard(List<Lesson> lessonsForDate) {
    if (now.isAfter(DateTime.parse(lessonsForDate.first.start)) &&
        now.isBefore(DateTime.parse(lessonsForDate.first.end))) {
      return RightNowCard(lesson: lessonsForDate.first);
    }
    return SizedBox.shrink();
  }

  List<Widget> _buildNextClassesChildren(List<Lesson> lessonsForDate) {
    return lessonsForDate
        .asMap()
        .entries
        .map((entry) {
      final lessonIndex = entry.key;
      final lesson = entry.value;
      return UpcomingClass(
        lesson: lesson,
        extend: lessonIndex == 0,
      );
    }).toList();
  }

  Widget _buildNextOrUpcomingClasses(
      DateTime currentDate, List<Lesson> lessonsForDate) {
    lessonsForDate = lessonsForDate
        .skip(now.isAfter(DateTime.parse(lessonsForDate.first.start)) &&
        now.isBefore(DateTime.parse(lessonsForDate.first.end))
        ? 1
        : 0)
        .toList();

    if (currentDate.day == now.day && lessonsForDate.isNotEmpty) {
      return NextClasses(
        children: _buildNextClassesChildren(lessonsForDate),
      );
    } else {
      return Column(
        children: lessonsForDate.map((lesson) {
          return UpcomingClass(lesson: lesson, extend: false);
        }).toList(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final lessons = Provider.of<DataProvider>(context).lessons;
    if (lessons == null) {
      // @TODO: add a retry button?
      return ErrorMessage(
        callback: fetchLessons,
      );
    }

    // filter upcoming lessons
    final upcomingLessons = lessons.where((lesson) {
      final lessonEnd = DateTime.parse(lesson.end);
      return lessonEnd.isAfter(now);
    }).toList();
    upcomingLessons.sort(
        (a, b) => DateTime.parse(a.start).compareTo(DateTime.parse(b.start)));
    final displayedLessons = upcomingLessons.take(7).toList();

    // group lessons by start date
    final groupedLessons = <String, List<Lesson>>{};
    for (var lesson in displayedLessons) {
      final lessonDate =
          DateFormat('yyyy-MM-dd').format(DateTime.parse(lesson.start));
      if (groupedLessons.containsKey(lessonDate)) {
        groupedLessons[lessonDate]!.add(lesson);
      } else {
        groupedLessons[lessonDate] = [lesson];
      }
    }

    return RefreshIndicator(
      onRefresh: () async {
        await Provider.of<DataProvider>(context, listen: false).fetchLessons();
      },
      child: ListView.builder(
        itemCount: 7,
        itemBuilder: (context, index) {
          final currentDate = now.add(Duration(days: index));
          final lessonDate = DateFormat('yyyy-MM-dd').format(currentDate);
          final lessonsForDate = groupedLessons[lessonDate] ?? [];

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            child: Column(
              children: [
                DateSection(date: currentDate),
                if (lessonsForDate.isNotEmpty) ...[
                  _buildNowCard(lessonsForDate),
                  _buildNextOrUpcomingClasses(currentDate, lessonsForDate),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class RightNowCard extends StatelessWidget {
  final Lesson lesson;

  const RightNowCard({
    super.key,
    required this.lesson,
  });

  String _formatTime(String dateTime) {
    final date = DateTime.parse(dateTime);
    return DateFormat.Hm().format(date);
  }

  @override
  Widget build(BuildContext context) {
    return FilledCard(
      onTap: () => showLessonBottomSheet(context, lesson),
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
    DateTime start = DateTime.parse(lesson.start);
    DateTime end = DateTime.parse(lesson.end);
    double progress = (DateTime.now().millisecondsSinceEpoch - start.millisecondsSinceEpoch) /
        (end.millisecondsSinceEpoch - start.millisecondsSinceEpoch);

    if (progress <= 0 || progress > 1) {
      progress = 0;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(_formatTime(lesson.start)),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: LinearProgressIndicator(
                value: progress,
                minHeight: 20,
                borderRadius: BorderRadius.circular(4)
            ),
          ),
        ),
        Text(_formatTime(lesson.end)),
      ],
    );
  }
}

class NextClasses extends StatelessWidget {
  final List<Widget> children;

  const NextClasses({
    super.key,
    required this.children,
  });

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

  String _formatTime(String dateTime) {
    final date = DateTime.parse(dateTime);
    return DateFormat.Hm().format(date);
  }

  Widget _buildDot() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: Text('•', style: TextStyle(fontSize: 22)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => showLessonBottomSheet(context, lesson),
      child: Column(
        children: [
          Row(
            children: [
              if (!extend) Text(_formatTime(lesson.start)),
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
                            TextSpan(text: _formatTime(lesson.start)),
                            const WidgetSpan(
                                child:
                                Icon(Icons.arrow_forward_rounded, size: 16)),
                            TextSpan(text: _formatTime(lesson.end)),
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
      ),
    );
  }
}
