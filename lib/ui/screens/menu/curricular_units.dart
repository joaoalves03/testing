import 'package:flutter/material.dart';
import 'package:goipvc/ui/widgets/card.dart';
import 'package:goipvc/utils/globals.dart';

class CurricularUnits extends StatefulWidget {
  const CurricularUnits({super.key});

  @override
  State<CurricularUnits> createState() => _CurricularUnitsState();
}

class _CurricularUnitsState extends State<CurricularUnits> {
  int selectedChip = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cadeiras"),
      ),
      body: ListView(
        children: [
          const GradeAverage(
            grade: 16.22,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8,
                children: [
                  OptionChip(
                    label: "Este Semestre",
                    selected: selectedChip == -1,
                    onSelected: (isSelected) {
                      if (isSelected) {
                        setState(() {
                          selectedChip = -1;
                        });
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
                        setState(() {
                          selectedChip = 0;
                        });
                      }
                    },
                  ),
                  OptionChip(
                    label: "1º ano",
                    selected: selectedChip == 1,
                    onSelected: (isSelected) {
                      if (isSelected) {
                        setState(() {
                          selectedChip = 1;
                        });
                      }
                    },
                  ),
                  OptionChip(
                    label: "2º ano",
                    selected: selectedChip == 2,
                    onSelected: (isSelected) {
                      if (isSelected) {
                        setState(() {
                          selectedChip = 2;
                        });
                      }
                    },
                  ),
                  OptionChip(
                    label: "3º ano",
                    selected: selectedChip == 3,
                    onSelected: (isSelected) {
                      if (isSelected) {
                        setState(() {
                          selectedChip = 3;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                CurricularUnitCard(
                  name: "Admistração de Base de Dados",
                  semester: 2,
                  ects: 5,
                  grade: 18,
                  onTap: () {},
                ),
                CurricularUnitCard(
                  name: "Projeto II",
                  semester: 2,
                  ects: 5,
                  grade: 19,
                ),
                CurricularUnitCard(
                  name: "Inteligência Artificial",
                  semester: 2,
                  ects: 5,
                ),
                CurricularUnitCard(
                  name: "Engenharia de Software II",
                  semester: 2,
                  ects: 5,
                  grade: 20,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class GradeAverage extends StatelessWidget {
  final double grade;

  const GradeAverage({
    super.key,
    required this.grade
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            Text(
              '$grade',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 40,
                fontWeight: FontWeight.bold
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Média Global",
                  style: TextStyle(
                    fontSize: 14,
                  )
                ),
                SizedBox(width: 6),
                Icon(
                  Icons.info,
                  size: 14,
                )
              ],
            )
          ],
        ),
      )
    );
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
              child: Wrap(
                spacing: 6,
                alignment: WrapAlignment.start,
                children: [
                  Icon(
                    Icons.school,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  Wrap(
                    direction: Axis.vertical,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold
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
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),

            if (grade != null)
              Stack(
                children: [
                  SizedBox(
                    width: 48,
                    height: 48,
                    child: CircularProgressIndicator(
                        value: grade! / 20,
                        backgroundColor: Theme.of(context).colorScheme.surfaceDim,
                        color: Theme.of(context).colorScheme.primary
                    ),
                  ),
                  SizedBox(
                    width: 48,
                    height: 48,
                    child: Center(
                        child: Text(
                          '$grade',
                          style: TextStyle(
                              fontSize: 18
                          ),
                        )
                    ),
                  )
                ],
              ),
          ],
        )
      ]
    );
  }

}