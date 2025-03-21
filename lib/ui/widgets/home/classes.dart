import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:goipvc/utils/globals.dart';
import 'package:goipvc/models/lesson.dart';
import 'package:goipvc/providers/data_providers.dart';
import 'package:goipvc/ui/widgets/error_message.dart';
import 'package:goipvc/ui/widgets/card.dart';
import 'package:goipvc/ui/widgets/lesson_sheet.dart';
import 'package:goipvc/ui/widgets/dot.dart';
import 'date_section.dart';

class ClassesTab extends ConsumerWidget {
  const ClassesTab({super.key});

  Widget _buildNowCard(List<Lesson> lessonsForDate) {
    final now = DateTime.now();
    if (now.isAfter(DateTime.parse(lessonsForDate.first.start)) &&
        now.isBefore(DateTime.parse(lessonsForDate.first.end))) {
      return RightNowCard(lesson: lessonsForDate.first);
    }
    return const SizedBox.shrink();
  }

  List<Widget> _buildNextClassesChildren(List<Lesson> lessonsForDate) {
    List<Widget> children = [];

    lessonsForDate.asMap().forEach((lessonIndex, lesson) {
      children.add(
        UpcomingClass(
          lesson: lesson,
          extend: lessonIndex == 0,
        ),
      );

      if (lessonIndex == 0 && lessonsForDate.length > 1) {
        children.add(SizedBox(height: 16));
      }
    });

    return children;
  }

  Widget _buildNextOrUpcomingClasses(
      DateTime currentDate, List<Lesson> lessonsForDate) {
    final now = DateTime.now();
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
          return UpcomingClass(lesson: lesson);
        }).toList(),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lessonsAsync = ref.watch(lessonsProvider);

    return lessonsAsync.when(
      data: (lessons) {
        final now = DateTime.now();

        // filter upcoming lessons
        final upcomingLessons = lessons.where((lesson) {
          final lessonEnd = DateTime.parse(lesson.end);
          return lessonEnd.isAfter(now);
        }).toList();

        // sort lessons
        upcomingLessons.sort((a, b) =>
            DateTime.parse(a.start).compareTo(DateTime.parse(b.start)));
        final displayedLessons = upcomingLessons.take(7).toList();

        // group lessons by start date
        final groupedLessons = <String, List<Lesson>>{};
        for (var lesson in displayedLessons) {
          final lessonDate =
              DateFormat('yyyy-MM-dd').format(DateTime.parse(lesson.start));
          groupedLessons.putIfAbsent(lessonDate, () => []).add(lesson);
        }

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(lessonsProvider);
          },
          child: ListView.builder(
            itemCount: 7,
            itemBuilder: (context, index) {
              final currentDate = now.add(Duration(days: index));
              final lessonDate = DateFormat('yyyy-MM-dd').format(currentDate);
              final lessonsForDate = groupedLessons[lessonDate] ?? [];

              if (currentDate != now || lessonsForDate.isNotEmpty) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  child: Column(
                    children: [
                      DateSection(
                        date: currentDate,
                        textColor: lessonsForDate.isNotEmpty
                            ? null
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      if (lessonsForDate.isNotEmpty) ...[
                        _buildNowCard(lessonsForDate),
                        _buildNextOrUpcomingClasses(
                            currentDate, lessonsForDate),
                      ],
                      SizedBox(height: currentDate == now ? 0 : 40)
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
        child: SizedBox(
          width: 50,
          height: 50,
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stackTrace) => ErrorMessage(
          error: error.toString(),
          stackTrace: stackTrace.toString(),
          callback: () {
            ref.invalidate(lessonsProvider);
          }),
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
      onTap: () => showLessonBottomSheet(context, lesson),
      children: [
        _buildTitleRow(context),
        _buildInfoRow(),
        SizedBox(height: 10),
        _buildProgressRow(),
      ],
    );
  }

  Widget _buildTitleRow(BuildContext context) {
    return Row(
      children: [
        Text(lesson.classType, style: TextStyle(fontWeight: FontWeight.w900)),
        Dot(),
        Expanded(
          child: Text(
            lesson.className,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }

  String _formatTeacherName(String name) {
    final parts = name.split(' ');
    if (parts.length <= 1) return name;
    return '${parts.first} ${parts.last}';
  }

  String _buildTeacherText(List<String> teachers) {
    if (teachers.isEmpty) return '';
    final formattedName = _formatTeacherName(teachers[0]);
    if (teachers.length == 1) return formattedName;
    return '$formattedName, +${teachers.length - 1}';
  }

  Widget _buildInfoRow() {
    return Row(
      children: [
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 2,
          children: [
            Icon(Icons.location_pin, size: 16),
            Text(lesson.room, style: const TextStyle(fontSize: 13)),
          ],
        ),
        Dot(),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 2,
          children: [
            Icon(lesson.teachers.length == 1 ? Icons.person : Icons.people,
                size: 16),
            Text(_buildTeacherText(lesson.teachers),
                style: const TextStyle(fontSize: 13)),
          ],
        ),
      ],
    );
  }

  Widget _buildProgressRow() {
    DateTime start = DateTime.parse(lesson.start);
    DateTime end = DateTime.parse(lesson.end);
    double progress =
        (DateTime.now().millisecondsSinceEpoch - start.millisecondsSinceEpoch) /
            (end.millisecondsSinceEpoch - start.millisecondsSinceEpoch);

    if (progress <= 0 || progress > 1) {
      progress = 0;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(formatTimeToHours(lesson.start)),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: LinearProgressIndicator(
                value: progress,
                minHeight: 20,
                borderRadius: BorderRadius.circular(4)),
          ),
        ),
        Text(formatTimeToHours(lesson.end)),
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

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => showLessonBottomSheet(context, lesson),
      child: Column(
        children: [
          Row(
            children: [
              if (!extend) Text(formatTimeToHours(lesson.start)),
              if (!extend) Dot(),
              Text(
                lesson.classType,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Dot(),
              Expanded(
                  child: Text(
                lesson.className,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: extend ? FontWeight.bold : FontWeight.normal),
              )),
            ],
          ),
          if (extend)
            Padding(
              padding: EdgeInsets.only(left: 26),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 2,
                    children: [
                      Icon(Icons.watch_later, size: 16),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(text: formatTimeToHours(lesson.start)),
                            WidgetSpan(
                                child: Icon(Icons.arrow_forward_rounded,
                                    size: 16)),
                            TextSpan(text: formatTimeToHours(lesson.end)),
                          ],
                        ),
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.location_on, size: 16),
                      SizedBox(width: 2),
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
