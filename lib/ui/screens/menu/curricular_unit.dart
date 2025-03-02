import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goipvc/providers/data_providers.dart';
import 'package:goipvc/models/curricular_unit.dart';
import 'package:goipvc/ui/widgets/curricular_unit/grade.dart';
import 'package:goipvc/ui/widgets/curricular_unit/grades_tab.dart';
import 'package:goipvc/ui/widgets/error_message.dart';

import 'package:goipvc/ui/widgets/curricular_unit/program_tab.dart';

class CurricularUnitScreen extends ConsumerWidget {
  final int curricularUnitId;

  const CurricularUnitScreen({
    super.key,
    required this.curricularUnitId
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final curricularUnitAsync = ref.watch(curricularUnitProvider(curricularUnitId));

    return Scaffold(
      appBar: AppBar(title: Text("Cadeira")),
      body: curricularUnitAsync.when(

        data: (curricularUnitData) {
          final CurricularUnit curricularUnit = curricularUnitData['unit'];
          final puc = curricularUnitData['puc'];

          return DefaultTabController(
            length: 4,
            child: Column(
              children: [
                UnitHeader(
                  curricularUnit: curricularUnit,
                  puc: puc,
                ),
                const TabBar(
                    tabs: [
                      Tab(icon: Icon(Icons.home), text: 'Geral'),
                      Tab(icon: Icon(Icons.date_range), text: 'Sumários'),
                      Tab(icon: Icon(Icons.school), text: 'Programa'),
                      Tab(icon: Icon(Icons.grading), text: 'Notas'),
                    ]
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      RefreshIndicator(
                          onRefresh: () async {
                            ref.invalidate(curricularUnitProvider);
                          },
                          child: Container()
                      ),

                      RefreshIndicator(
                          onRefresh: () async {
                            ref.invalidate(curricularUnitProvider);
                          },
                          child: Container()
                      ),

                      RefreshIndicator(
                        onRefresh: () async {
                          ref.invalidate(curricularUnitProvider);
                        },
                        child: ProgramTab(puc: puc)
                      ),

                      RefreshIndicator(
                          onRefresh: () async {
                            ref.invalidate(curricularUnitProvider);
                          },
                          child: GradesTab(grades: curricularUnit.grades)
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        loading: () =>  Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => ErrorMessage(
          error: error.toString(),
          stackTrace: stackTrace.toString(),
          callback: () async {
            ref.invalidate(curricularUnitProvider);
          },
        )
      )
    );
  }
}

class UnitHeader extends StatelessWidget {
  final CurricularUnit curricularUnit;
  final Map<String, dynamic> puc;

  const UnitHeader({
    super.key,
    required this.curricularUnit,
    required this.puc
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                        label: Text(
                          "PL: ${puc['pl_horas']?.toString() ?? '--'} horas",
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                      ),
                      Chip(
                        label: Text(
                          "TP: ${puc['tp_horas']?.toString() ?? '--'} horas",
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          if (curricularUnit.finalGrade != null) ...[
            const SizedBox(width: 20),
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
    );
  }

}