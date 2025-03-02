import 'package:flutter/material.dart';

class Grade extends StatelessWidget{
  final int? grade;

  const Grade({
    super.key,
    this.grade
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: 48,
          height: 48,
          child: CircularProgressIndicator(
            value: grade != null
                ? grade! / 20
                : 0,
            backgroundColor: Theme.of(context).colorScheme.surfaceDim,
            color: Theme.of(context).colorScheme.primary,
            strokeWidth: 5,
          ),
        ),
        SizedBox(
          width: 48,
          height: 48,
          child: Center(
            child: Text(
              grade != null ? grade.toString() : "--",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
        ),
      ],
    );
  }

}