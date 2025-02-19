import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget buildDot(BuildContext context, {Color? textColor, double? size}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 4),
    child: Text(
        '•',
        style: TextStyle(
          fontSize: size ?? 22,
          color: textColor ?? Theme.of(context).colorScheme.onSurface,
          height: 0
        )
    ),
  );
}

String formatTimeToHours(String dateTime) {
  final date = DateTime.parse(dateTime);
  return DateFormat.Hm().format(date);
}