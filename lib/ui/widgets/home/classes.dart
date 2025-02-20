import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goipvc/models/lesson.dart';
import 'package:goipvc/providers/data_providers.dart';
import 'package:goipvc/ui/widgets/error_message.dart';
import 'package:goipvc/ui/widgets/card.dart';
import 'package:goipvc/ui/widgets/lesson_sheet.dart';
import 'package:intl/intl.dart';
import 'package:goipvc/utils/globals.dart';
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
    return lessonsForDate.asMap().entries.map((entry) {
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
          return UpcomingClass(lesson: lesson, extend: false);
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

              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
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
      },
      loading: () => const Center(
        child: SizedBox(
          width: 50,
          height: 50,
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stack) => ErrorMessage(callback: () {
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
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
              if (!extend) buildDot(context),
              Text(lesson.classType),
              buildDot(context),
              Text(
                lesson.className,
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
            ],
          ),
          if (extend)
            Padding(
              padding: const EdgeInsets.only(left: 22),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.watch_later, size: 16),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(text: formatTimeToHours(lesson.start)),
                            const WidgetSpan(
                                child: Icon(Icons.arrow_forward_rounded,
                                    size: 16)),
                            TextSpan(text: formatTimeToHours(lesson.end)),
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
