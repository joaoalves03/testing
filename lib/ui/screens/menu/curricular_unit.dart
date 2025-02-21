import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goipvc/models/curricular_unit.dart';
import 'package:goipvc/ui/widgets/curricular_unit/grade.dart';

class CurricularUnitScreen extends ConsumerWidget {
  final CurricularUnit curricularUnit;

  const CurricularUnitScreen({
    super.key,
    required this.curricularUnit
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Disciplina"),
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          curricularUnit.name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Wrap(
                            spacing: 4,
                            children: [
                              Chip(
                                label: Text("PL: -- horas"),
                                padding: EdgeInsets.symmetric(horizontal: 2),
                              ),
                              Chip(
                                label: Text("TP: -- horas"),
                                padding: EdgeInsets.symmetric(horizontal: 2),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  if(curricularUnit.finalGrade != null) ...[
                    SizedBox(width: 20),
                    Wrap(
                      spacing: 8,
                      direction: Axis.vertical,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          "Nota Final",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Grade(grade: curricularUnit.finalGrade!),
                      ],
                    )
                  ]
                ],
              ),
            ),
            TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.home), text: 'Geral'),
                  Tab(icon: Icon(Icons.date_range), text: 'Sumários'),
                  Tab(icon: Icon(Icons.school), text: 'Programa'),
                  Tab(icon: Icon(Icons.grading), text: 'Notas'),
                ]
            )
          ],
        ),
      )
    );
  }
}