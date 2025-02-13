import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:goipvc/models/lesson.dart';
import 'package:goipvc/ui/widgets/lesson_sheet.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final CalendarController _calendarController = CalendarController();
  CalendarView _currentView = CalendarView.week;
  MeetingDataSource _getDataSource() {
    return MeetingDataSource([
      Lesson(
        shortName: "SO",
        className: "Sistemas Operativos",
        classType: "PL",
        start: "2025-02-02T09:00:00",
        end: "2025-02-02T10:00",
        id: "1",
        teachers: ["Vitor Ferreira"],
        room: "S2.1",
        statusColor: "#FF0000",
      ),
      Lesson(
        shortName: "BD",
        className: "Bases de Dados",
        classType: "TP",
        start: "2025-02-02T10:00",
        end: "2025-02-02T12:00",
        id: "2",
        teachers: ["Ana Oliveira"],
        room: "S3.2",
        statusColor: "#00FF00",
      ),
      Lesson(
        shortName: "AED",
        className: "Algoritmos e Estruturas de Dados",
        classType: "TP",
        start: "2025-02-03T08:00",
        end: "2025-02-03T09:30",
        id: "3",
        teachers: ["Carlos Costa"],
        room: "A1.1",
        statusColor: "#0000FF",
      ),
      Lesson(
        shortName: "PDI",
        className: "Processamento Digital de Imagem",
        classType: "PL",
        start: "2025-02-03T16:30",
        end: "2025-02-03T18:30",
        id: "4",
        teachers: ["Joana Martins"],
        room: "L4.2",
        statusColor: "#FFA500",
      ),
    ]);
  }
  String _headerText = "Month Year";

  void _showSettingsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return Settings(
          onViewChanged: _updateView,
          currentView: _currentView,
        );
      },
    );
  }

  void _updateView(CalendarView newView, BuildContext context) {
    setState(() => _currentView = newView);
    _calendarController.view = newView;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
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
                        Text(_headerText.capitalize(),
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18),
                        )
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
            child: SfCalendar(
              headerHeight: 0,
              firstDayOfWeek: 1,
              cellEndPadding: 0,
              allowViewNavigation: true,
              view: _currentView,
              monthViewSettings: MonthViewSettings(showAgenda: true),
              timeSlotViewSettings: TimeSlotViewSettings(
                dateFormat: 'd',
                dayFormat: 'EEE',
                timeFormat: 'H:mm',
                startHour: 7,
                endHour: 24
              ),
              selectionDecoration: _currentView != CalendarView.month
                  ? BoxDecoration(
                      color: Colors.transparent
                  )
                  : null,

              controller: _calendarController,
              dataSource: _getDataSource(),
              onTap: (CalendarTapDetails tap) {
                if (tap.targetElement == CalendarElement.appointment) {
                  showLessonBottomSheet(context, tap.appointments![0]);
                }
              },
              onViewChanged: (ViewChangedDetails viewChangedDetails) {
                String newHeader = DateFormat('MMMM yyyy').format(
                  viewChangedDetails.visibleDates[viewChangedDetails.visibleDates.length ~/ 2],
                );

                SchedulerBinding.instance.addPostFrameCallback((_) {
                  if (mounted) {
                    setState(() {
                      _headerText = newHeader;
                    });
                  }
                });
              },
            ),
          )
        ],
      )
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return
      "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Lesson> source){
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return DateTime.parse(appointments![index].start);
  }

  @override
  DateTime getEndTime(int index) {
    return DateTime.parse(appointments![index].end);
  }

  @override
  String getSubject(int index) {
    return "${appointments![index].shortName}\n${appointments![index].room}";
  }

  @override
  Color getColor(int index) {
    return Color(
        int.parse(appointments![index].statusColor.substring(1), radix: 16) + 0xFF000000);
  }
}

class Settings extends StatelessWidget {
  final Function(CalendarView, BuildContext) onViewChanged;
  final CalendarView currentView;

  const Settings({
    super.key,
    required this.onViewChanged,
    required this.currentView,
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
                  view: CalendarView.week,
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
        ],
      ),
    );
  }

  Widget _buildViewOption(BuildContext context, {required IconData icon, required String label, required CalendarView view}) {
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
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      color: currentView == view
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                    )
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}