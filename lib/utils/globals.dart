import 'package:intl/intl.dart';

String formatTimeToHours(String dateTime) {
  final date = DateTime.parse(dateTime);
  return DateFormat.Hm().format(date);
}