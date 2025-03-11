import 'package:flutter/material.dart';

class Dot extends StatelessWidget {
  final Color? textColor;
  final double? size;

  const Dot({super.key, this.textColor, this.size});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Icon(
        Icons.fiber_manual_record,
        size: size ?? 8,
        color: textColor ?? Theme.of(context).colorScheme.onSurface,
      )
    );
  }
}