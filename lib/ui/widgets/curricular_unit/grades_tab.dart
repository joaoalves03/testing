import 'package:flutter/material.dart';
import 'package:goipvc/models/curricular_unit.dart';
import 'package:goipvc/ui/widgets/card.dart';
import 'package:goipvc/ui/widgets/curricular_unit/grade.dart';

class GradesTab extends StatelessWidget {
  final List<UnitGrade> grades;

  const GradesTab({super.key, required this.grades});

  @override
  Widget build(BuildContext context) {
    final reversedGrades = grades.reversed.toList();

    if (reversedGrades.isEmpty) {
      return const Center(child: Text("No grades available"));
    }

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: reversedGrades.map((grade) => SizedBox(
              width: (constraints.maxWidth - 12) / 2,
              child: FilledCard(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Grade(grade: grade.value),
                        SizedBox(height: 8),
                        Text(
                            grade.evaluationType ?? "Sem tipo",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold
                            )
                        ),
                        Text(grade.date ?? "Sem data",
                            style: Theme.of(context).textTheme.labelSmall),
                      ],
                    ),
                  )
                ]
              )
            )).toList(),
          ),
        ),
      ),
    );
  }
}