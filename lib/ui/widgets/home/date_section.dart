import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateSection extends StatelessWidget {
  final DateTime date;
  final Color? textColor;

  const DateSection({
    super.key,
    required this.date,
    this.textColor
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    String day;

    if (date.difference(today).inDays == 0) {
      day = "Hoje";
    } else if (date.difference(today).inDays == 1) {
      day = "Amanhã";
    } else {
      day = DateFormat.EEEE('pt').format(date);
    }

    String formattedDate = DateFormat("dd MMMM yyyy", 'pt').format(date);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          toBeginningOfSentenceCase(day),
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: textColor ?? Theme.of(context).colorScheme.onSurface
          ),
        ),

        // Right text (formatted date)
        Text(
          formattedDate,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
