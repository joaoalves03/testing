import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goipvc/models/curricular_unit.dart';
import 'package:goipvc/ui/widgets/curricular_unit/grade.dart';

class CurricularUnitScreen extends ConsumerWidget {
  final int curricularUnitId;

  const CurricularUnitScreen({
    super.key,
    required this.curricularUnitId
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final curricularUnitAsync = ref.watch(curricularUnitProvider(curricularUnitId));

    return curricularUnitAsync.when(
      loading: () => Scaffold(
        appBar: AppBar(title: const Text("Disciplina")),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        appBar: AppBar(title: const Text("Disciplina")),
        body: Center(child: Text('Error: $error')),
      ),
      data: (curricularUnit) => _buildContent(context, curricularUnit),
    );
  }

  Widget _buildContent(BuildContext context, CurricularUnit curricularUnit) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Disciplina"),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
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
            const TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.home), text: 'Geral'),
                  Tab(icon: Icon(Icons.date_range), text: 'Sumários'),
                  Tab(icon: Icon(Icons.school), text: 'Programa'),
                  Tab(icon: Icon(Icons.grading), text: 'Notas'),
                ]
            )
          ],
        ),
      ),
    );
  }
}