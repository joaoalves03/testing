import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goipvc/models/curricular_unit.dart';
import 'package:goipvc/providers/data_providers.dart';

import 'package:goipvc/ui/widgets/card.dart';

class AttendanceTab extends ConsumerWidget {
  final CurricularUnit curricularUnit;

  const AttendanceTab({
    super.key,
    required this.curricularUnit
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(curricularUnitProvider);
        },
        child: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            Row(
              children: [
                AttendanceCard(
                  type: "TP",
                  quantity: 7,
                  total: 10,
                  attendanceClass: "A",
                ),
                SizedBox(width: 10),
                AttendanceCard(
                  type: "PL",
                  quantity: 7,
                  total: 10,
                  attendanceClass: "A",
                ),
                SizedBox(width: 10),
                AttendanceCard(
                  type: "T",
                  quantity: 7,
                  total: 10,
                  attendanceClass: "A",
                ),
              ],
            )
          ],
        )
    );
  }
}

class AttendanceCard extends StatelessWidget{
  final String type;
  final double quantity;
  final double total;
  final String attendanceClass;

  const AttendanceCard({
    super.key,
    required this.type,
    required this.quantity,
    required this.total,
    required this.attendanceClass,
  });

  @override
  Widget build(BuildContext context) {
    final double percentage = quantity / total;

    return Expanded(
      child: FilledCard(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                    type,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                    )
                ),
                SizedBox(height: 8),
                Stack(
                  children: [
                    SizedBox(
                      width: 54,
                      height: 54,
                      child: CircularProgressIndicator(
                        value: percentage,
                        backgroundColor: Theme.of(context).colorScheme.surfaceDim,
                        color: Theme.of(context).colorScheme.primary,
                        strokeWidth: 5,
                      ),
                    ),
                    SizedBox(
                      width: 54,
                      height: 54,
                      child: Center(
                        child: Text(
                          "${(percentage * 100).toInt()}%",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                    "$quantity/$total",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 16
                    )
                ),
                Text(
                    "Turma $attendanceClass",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: 14
                    )
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

}
