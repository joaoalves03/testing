import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goipvc/providers/data_providers.dart';
import 'package:goipvc/models/curricular_unit.dart';
import 'package:goipvc/ui/screens/menu/curricular_unit.dart';
import 'package:goipvc/ui/widgets/error_message.dart';
import 'package:goipvc/ui/widgets/list_section.dart';
import 'package:goipvc/ui/widgets/card.dart';
import 'package:goipvc/ui/widgets/dot.dart';
import 'package:goipvc/ui/widgets/curricular_unit/grade.dart';

final selectedChipProvider = StateProvider.autoDispose<int>((ref) => -1);

class CurricularUnitsScreen extends ConsumerWidget {
  const CurricularUnitsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedChip = ref.watch(selectedChipProvider);
    final curricularUnitsAsync = ref.watch(curricularUnitsProvider);
    final averageGradeAsync = ref.watch(averageGradeProvider);

    return Scaffold(
        appBar: AppBar(
          title: Text("Cadeiras"),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(curricularUnitsResponseProvider);
          },
          child: ListView(
            children: [
              averageGradeAsync.when(
                data: (grade) => GradeAverage(grade: grade),
                loading: () => const GradeAverage(loading: true),
                error: (_, __) => const GradeAverage(error: true),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8,
                    children: [
                      OptionChip(
                        label: "Este Semestre",
                        selected: selectedChip == -1,
                        onSelected: (isSelected) {
                          if (isSelected) {
                            ref.read(selectedChipProvider.notifier).state = -1;
                          }
                        },
                      ),
                      Container(
                        width: 2,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.outline,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      OptionChip(
                        label: "Tudo",
                        selected: selectedChip == 0,
                        onSelected: (isSelected) {
                          if (isSelected) {
                            ref.read(selectedChipProvider.notifier).state = 0;
                          }
                        },
                      ),
                      OptionChip(
                        label: "1º ano",
                        selected: selectedChip == 1,
                        onSelected: (isSelected) {
                          if (isSelected) {
                            ref.read(selectedChipProvider.notifier).state = 1;
                          }
                        },
                      ),
                      OptionChip(
                        label: "2º ano",
                        selected: selectedChip == 2,
                        onSelected: (isSelected) {
                          if (isSelected) {
                            ref.read(selectedChipProvider.notifier).state = 2;
                          }
                        },
                      ),
                      OptionChip(
                        label: "3º ano",
                        selected: selectedChip == 3,
                        onSelected: (isSelected) {
                          if (isSelected) {
                            ref.read(selectedChipProvider.notifier).state = 3;
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              curricularUnitsAsync.when(
                data: (curricularUnits) {
                  List<CurricularUnit> filteredUnits = [];
                  if (selectedChip == -1) {
                    if (curricularUnits.isNotEmpty) {
                      final academicYear = "2024-25";
                      filteredUnits = curricularUnits
                          .where((unit) =>
                                  unit.grades.last.academicYear ==
                                      academicYear &&
                                  unit.semester ==
                                      2 // TODO: actually use a good check
                              )
                          .toList();
                    }
                  } else if (selectedChip == 0) {
                    filteredUnits = curricularUnits;
                  } else {
                    filteredUnits = curricularUnits
                        .where((unit) => unit.year == selectedChip)
                        .toList();
                  }

                  if (selectedChip == -1 && filteredUnits.isEmpty) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      ref.read(selectedChipProvider.notifier).state = 0;
                    });
                  }

                  Map<int, List<CurricularUnit>> unitsByYear = {};
                  for (var unit in filteredUnits) {
                    unitsByYear.putIfAbsent(unit.year, () => []).add(unit);
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        for (var year in unitsByYear.keys)
                          ListSection(
                            title: "$yearº ano",
                            children: [
                              for (var curricularUnit in unitsByYear[year]!)
                                CurricularUnitCard(
                                  name: curricularUnit.name,
                                  semester: curricularUnit.semester,
                                  ects: curricularUnit.ects,
                                  grade: curricularUnit.finalGrade,
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CurricularUnitScreen(
                                                  curricularUnitId:
                                                      curricularUnit.id,
                                                )));
                                  },
                                ),
                            ],
                          ),
                      ],
                    ),
                  );
                },
                loading: () => Column(
                  children: [SizedBox(height: 60), CircularProgressIndicator()],
                ),
                error: (error, stackTrace) => Column(
                  children: [
                    SizedBox(height: 60),
                    ErrorMessage(
                        error: error.toString(),
                        stackTrace: stackTrace.toString(),
                        callback: () async {
                          ref.invalidate(curricularUnitsResponseProvider);
                        }),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}

class GradeAverage extends StatelessWidget {
  final double? grade;
  final bool loading;
  final bool error;

  const GradeAverage({
    super.key,
    this.grade,
    this.loading = false,
    this.error = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          if (loading && !error)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: CircularProgressIndicator(),
            )
          else if (error) ...[
            Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  'Não foi possível obter a média',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ))
          ] else
            Text(
              '$grade',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 40,
                  fontWeight: FontWeight.bold),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Média Global",
                  style: TextStyle(
                    fontSize: 14,
                  )),
              SizedBox(width: 6),
              Icon(
                Icons.info,
                size: 14,
              )
            ],
          )
        ],
      ),
    ));
  }
}

class OptionChip extends StatelessWidget {
  final String label;
  final bool selected;
  final ValueChanged<bool>? onSelected;

  const OptionChip({
    super.key,
    required this.label,
    required this.selected,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: onSelected ?? (isSelected) {},
      labelPadding: EdgeInsets.symmetric(horizontal: 4),
      showCheckmark: false,
    );
  }
}

class CurricularUnitCard extends StatelessWidget {
  final String name;
  final int semester;
  final int ects;
  final int? grade;
  final void Function()? onTap;

  const CurricularUnitCard({
    super.key,
    required this.name,
    required this.semester,
    required this.ects,
    this.grade,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FilledCard(
      onTap: onTap,
      children: [
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: grade != null ? 0 : 3),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.school,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    SizedBox(width: 6),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                '$semesterº Semestre',
                                style: TextStyle(
                                  fontSize: 10,
                                ),
                              ),
                              Dot(size: 16),
                              Text(
                                '$ects ECTS',
                                style: TextStyle(
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (grade != null) ...[SizedBox(width: 10), Grade(grade: grade!)]
          ],
        ),
      ],
    );
  }
}
