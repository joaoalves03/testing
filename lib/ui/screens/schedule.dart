import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:goipvc/models/lesson.dart';
import 'package:goipvc/models/task.dart';
import 'package:goipvc/models/holiday.dart';
import 'package:goipvc/ui/widgets/lesson_sheet.dart';
import 'package:goipvc/ui/widgets/error_message.dart';
import 'package:goipvc/providers/data_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ScheduleScreen extends ConsumerStatefulWidget {
  const ScheduleScreen({super.key});

  @override
  ConsumerState<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends ConsumerState<ScheduleScreen> {
  final CalendarController _calendarController = CalendarController();
  CalendarView _currentView = CalendarView.week;
  final ValueNotifier<bool> _showWeekends = ValueNotifier<bool>(true);
  late String _headerText;

  static const String calendarViewKey = 'calendar_view';

  // todo: THIS IS TEMPORARY SHOULD BE SWITCHED TO ACTUAL DATA FROM API
  final List<Holiday> _holidays = [
    Holiday(
      title: "",
      start: "2024-12-08",
      end: "2024-12-08",
    ),
    Holiday(
      title: "Christmas",
      start: "2024-12-23",
      end: "2025-01-04",
    ),
  ];
  final List<Task> _tasks = [
    Task(
      id: 1,
      title: "Complete Project",
      due: "2025-02-03T00:00:00",
      className: "SO",
      type: "Project",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _headerText = DateFormat('MMMM yyyy').format(DateTime.now());
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? savedViewString = prefs.getString("calendar_view");

    setState(() {
      if (savedViewString != null) {
        _currentView = _getCalendarViewFromString(savedViewString);
        _showWeekends.value = _currentView != CalendarView.workWeek;
      }
    });

    _calendarController.view = _currentView;
  }

  CalendarView _getCalendarViewFromString(String viewString) {
    switch (viewString) {
      case 'day':
        return CalendarView.day;
      case 'week':
        return CalendarView.week;
      case 'workWeek':
        return CalendarView.workWeek;
      case 'month':
        return CalendarView.month;
      default:
        return CalendarView.week;
    }
  }

  String _getStringFromCalendarView(CalendarView view) {
    switch (view) {
      case CalendarView.day:
        return 'day';
      case CalendarView.week:
        return 'week';
      case CalendarView.workWeek:
        return 'workWeek';
      case CalendarView.month:
        return 'month';
      default:
        return 'week';
    }
  }

  Future<void> _savePreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        calendarViewKey, _getStringFromCalendarView(_currentView));
  }

  MeetingDataSource _getDataSource(List<Lesson> lessons) {
    return MeetingDataSource(lessons, _tasks, _holidays);
  }

  List<TimeRegion> _getTimeRegions() {
    List<TimeRegion> regions = [];
    final surfaceColor = Theme.of(context).colorScheme.surfaceContainer;

    if (_currentView == CalendarView.day) {
      return _holidays.map((holiday) {
        return TimeRegion(
          startTime: DateTime.parse(holiday.start).subtract(Duration(days: 1)),
          endTime: DateTime.parse(holiday.end).add(Duration(days: 1)),
          enablePointerInteraction: false,
          color: surfaceColor,
        );
      }).toList();
    }

    for (var holiday in _holidays) {
      DateTime startDate = DateFormat("yyyy-MM-dd").parse(holiday.start);
      DateTime endDate = DateFormat("yyyy-MM-dd").parse(holiday.end);

      for (DateTime date = startDate;
          date.isBefore(endDate.add(Duration(days: 1)));
          date = date.add(Duration(days: 1))) {
        regions.add(
          TimeRegion(
            startTime: date,
            endTime: date.add(Duration(days: 1)),
            enablePointerInteraction: false,
            color: surfaceColor,
          ),
        );
      }
    }

    return regions;
  }

  void _showSettingsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return SafeArea(
          child: Settings(
            onViewChanged: _updateView,
            currentView: _currentView,
            showWeekends: _showWeekends,
            onToggleWeekends: _toggleWeekends,
          ),
        );
      },
    );
  }

  void _updateView(CalendarView newView, BuildContext context) {
    setState(() {
      _currentView = newView;
    });
    _calendarController.view = _currentView;
    _calendarController.displayDate = DateTime.now();
    _calendarController.selectedDate = DateTime.now();
    _savePreferences();
    Navigator.pop(context);
  }

  void _toggleWeekends(bool value) {
    _showWeekends.value = value;
    setState(() {
      if (_currentView == CalendarView.week ||
          _currentView == CalendarView.workWeek) {
        _currentView = value ? CalendarView.week : CalendarView.workWeek;
      }
    });
    _calendarController.view = _currentView;
    _savePreferences();
  }

  @override
  Widget build(BuildContext context) {
    final lessonsAsync = ref.watch(lessonsProvider);

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: SizedBox(
              height: 40,
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          toBeginningOfSentenceCase(_headerText),
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.today),
                    onPressed: () {
                      _calendarController.displayDate = DateTime.now();
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.settings),
                    onPressed: () {
                      _showSettingsSheet(context);
                    },
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: lessonsAsync.when(
              data: (lessons) {
                return SfCalendar(
                  headerHeight: 0,
                  firstDayOfWeek: 1,
                  cellEndPadding: 0,
                  allowViewNavigation: true,
                  view: _currentView,
                  monthViewSettings: MonthViewSettings(
                    showAgenda: true,
                    appointmentDisplayMode:
                        MonthAppointmentDisplayMode.indicator,
                  ),
                  timeSlotViewSettings: TimeSlotViewSettings(
                    dateFormat: 'd',
                    dayFormat: 'EEE',
                    timeFormat: 'H:mm',
                    startHour: 7,
                    endHour: 24,
                  ),
                  selectionDecoration: _currentView != CalendarView.month
                      ? BoxDecoration(color: Colors.transparent)
                      : null,
                  controller: _calendarController,
                  specialRegions: _getTimeRegions(),
                  dataSource: _getDataSource(lessons),
                  onTap: (CalendarTapDetails tap) {
                    if (tap.targetElement == CalendarElement.appointment &&
                        tap.appointments![0] is Lesson) {
                      showLessonBottomSheet(context, tap.appointments![0]);
                    }
                  },
                  onViewChanged: (ViewChangedDetails viewChangedDetails) {
                    String newHeader = DateFormat('MMMM yyyy').format(
                      viewChangedDetails.visibleDates[
                          viewChangedDetails.visibleDates.length ~/ 2],
                    );

                    SchedulerBinding.instance.addPostFrameCallback((_) {
                      if (mounted) {
                        setState(() {
                          if (_currentView == CalendarView.month &&
                              _calendarController.view == CalendarView.day) {
                            _currentView = CalendarView.day;
                            _savePreferences();
                          }

                          if (_currentView == CalendarView.week &&
                              _calendarController.view == CalendarView.day) {
                            _currentView = CalendarView.day;
                            _savePreferences();
                          }

                          if (_currentView == CalendarView.workWeek &&
                              _calendarController.view == CalendarView.day) {
                            _currentView = CalendarView.day;
                            _savePreferences();
                          }
                          _headerText = newHeader;
                        });
                      }
                    });
                  },
                );
              },
              loading: () => Center(
                  child: SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(),
              )),
              error: (error, stackTrace) => ErrorMessage(
                  error: error.toString(),
                  stackTrace: stackTrace.toString(),
                  callback: () {
                    ref.invalidate(lessonsProvider);
                  }),
            ),
          )
        ],
      ),
    );
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(
      List<Lesson> lessons, List<Task> tasks, List<Holiday> holidays) {
    appointments = [];
    appointments!.addAll(lessons);

    appointments!.addAll(tasks.map((task) => Appointment(
          startTime: DateTime.parse(task.due),
          endTime: DateTime.parse(task.due).add(Duration(hours: 1)),
          subject: task.title,
          color: Colors.blue,
          isAllDay: true,
        )));

    appointments!.addAll(holidays.map((holiday) => Appointment(
          startTime: DateTime.parse(holiday.start),
          endTime: DateTime.parse(holiday.end),
          subject: holiday.title,
          color: Colors.grey,
          isAllDay: true,
        )));
  }

  @override
  DateTime getStartTime(int index) {
    if (appointments![index] is Lesson) {
      return DateTime.parse((appointments![index] as Lesson).start);
    }
    return DateTime.now();
  }

  @override
  DateTime getEndTime(int index) {
    if (appointments![index] is Lesson) {
      return DateTime.parse((appointments![index] as Lesson).end);
    }
    return DateTime.now();
  }

  @override
  String getSubject(int index) {
    if (appointments![index] is Lesson) {
      Lesson lesson = (appointments![index] as Lesson);
      return "${lesson.shortName}\n${lesson.room}";
    }
    return "";
  }

  @override
  Color getColor(int index) {
    if (appointments![index] is Lesson) {
      return Color(int.parse(
              (appointments![index] as Lesson).statusColor.substring(1),
              radix: 16) +
          0xFF000000);
    }
    return Colors.grey;
  }
}

class Settings extends StatelessWidget {
  final Function(CalendarView, BuildContext) onViewChanged;
  final CalendarView currentView;
  final ValueNotifier<bool> showWeekends;
  final Function(bool) onToggleWeekends;

  const Settings({
    super.key,
    required this.onViewChanged,
    required this.currentView,
    required this.showWeekends,
    required this.onToggleWeekends,
  });

  @override
  Widget build(BuildContext context) {
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
          Text(
            "Layout",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(8),
            ),
            clipBehavior: Clip.hardEdge,
            child: Row(
              children: [
                _buildViewOption(
                  context,
                  icon: Icons.view_day_rounded,
                  label: 'Dia',
                  view: CalendarView.day,
                ),
                _buildViewOption(
                  context,
                  icon: Icons.view_week_rounded,
                  label: 'Semana',
                  view: showWeekends.value
                      ? CalendarView.week
                      : CalendarView.workWeek,
                ),
                _buildViewOption(
                  context,
                  icon: Icons.view_agenda_rounded,
                  label: 'Mês',
                  view: CalendarView.month,
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Text(
            "Opções",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Column(
            children: [
              _buildOption(
                context,
                label: "Fim de Semana",
                tailing: ValueListenableBuilder<bool>(
                  valueListenable: showWeekends,
                  builder: (context, value, child) {
                    return Switch(
                      value: currentView == CalendarView.week ||
                              currentView == CalendarView.workWeek
                          ? value
                          : true,
                      onChanged: currentView == CalendarView.week ||
                              currentView == CalendarView.workWeek
                          ? (newValue) {
                              showWeekends.value = newValue;
                              onToggleWeekends(newValue);
                            }
                          : null,
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildViewOption(
    BuildContext context, {
    required IconData icon,
    required String label,
    required CalendarView view,
  }) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onViewChanged(view, context),
          child: Container(
            padding: EdgeInsets.all(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 32,
                  color: currentView == view
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                  decoration: BoxDecoration(
                    color: currentView == view
                        ? Theme.of(context).colorScheme.primary
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(1000),
                  ),
                  child: Text(label,
                      style: TextStyle(
                        fontSize: 14,
                        color: currentView == view
                            ? Theme.of(context).colorScheme.onPrimary
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOption(
    BuildContext context, {
    required String label,
    required Widget tailing,
  }) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(8),
        ),
        clipBehavior: Clip.hardEdge,
        child: Row(
          children: [
            Text(label),
            Spacer(),
            tailing,
          ],
        ));
  }
}
