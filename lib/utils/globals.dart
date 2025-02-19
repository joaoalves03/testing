import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Dot extends StatelessWidget {
  final Color? textColor;
  final double? size;

  const Dot({super.key, this.textColor, this.size});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        '•',
        style: TextStyle(
          fontSize: size ?? 22,
          color: textColor ?? Theme.of(context).colorScheme.onSurface,
          height: 0,
        ),
      ),
    );
  }
}

String formatTimeToHours(String dateTime) {
  final date = DateTime.parse(dateTime);
  return DateFormat.Hm().format(date);
}