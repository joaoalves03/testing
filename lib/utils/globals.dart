import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget buildDot() {
  return const Padding(
    padding: EdgeInsets.symmetric(horizontal: 4),
    child: Text('•', style: TextStyle(fontSize: 22)),
  );
}

String formatTimeToHours(String dateTime) {
  final date = DateTime.parse(dateTime);
  return DateFormat.Hm().format(date);
}