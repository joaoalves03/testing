import 'package:flutter/material.dart';
import 'package:goipvc/models/tuition_fee.dart';
import 'package:goipvc/providers/data_providers.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goipvc/ui/widgets/card.dart';

class TuitionFeesScreen extends ConsumerWidget {
  const TuitionFeesScreen({super.key});

  List<TuitionFee> _sortTuitionFeesByDate(List<TuitionFee> fees) {
    fees.sort((a, b) {
      DateTime dateA = DateFormat("dd-MM-yyyy").parse(a.dueDate);
      DateTime dateB = DateFormat("dd-MM-yyyy").parse(b.dueDate);
      return dateA.compareTo(dateB);
    });
    return fees;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tuitionFeesAsync = ref.watch(tuitionsProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Propinas"),
        ),
        body: tuitionFeesAsync.when(
          data: (tuitionFees) {
            final paidTuitions = _sortTuitionFeesByDate(tuitionFees
                .where((tuitionFee) =>
                    tuitionFee.amountPaid > 0 && tuitionFee.fine == 0)
                .toList());

            final debtTuitions = _sortTuitionFeesByDate(tuitionFees
                .where(
                    (tuitionFee) => tuitionFee.debt > 0 || tuitionFee.fine > 0)
                .toList());

            return Column(
              children: [
                TabBar(
                  tabs: [
                    Tab(icon: Icon(Icons.payments), text: 'Dívidas'),
                    Tab(icon: Icon(Icons.paid), text: 'Pago'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        child: ListView(
                          children: <Widget>[
                            for (var debtTuition in debtTuitions)
                              TuitionFeeCard(tuitionFee: debtTuition)
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        child: ListView(
                          children: <Widget>[
                            for (var paidTuition in paidTuitions)
                              TuitionFeeCard(tuitionFee: paidTuition)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
          loading: () => Center(child: CircularProgressIndicator()),
          error: (e, stackTrace) =>
              Center(child: Text('Failed to load tuition fees')),
        ),
      ),
    );
  }
}

class TuitionFeeCard extends StatelessWidget {
  final TuitionFee tuitionFee;

  const TuitionFeeCard({super.key, required this.tuitionFee});

  @override
  Widget build(BuildContext context) {
    DateTime date = DateFormat("dd-MM-yyyy").parse(tuitionFee.dueDate);
    String month = DateFormat.MMMM().format(date);
    DateTime dueDate = DateFormat("dd-MM-yyyy").parse(tuitionFee.dueDate);
    DateTime now = DateTime.now();

    bool isCurrentMonth = DateFormat.MMMM().format(now) == month;
    bool isOverdue = dueDate.isBefore(DateTime(now.year, now.month)) &&
        tuitionFee.amountPaid == 0 &&
        tuitionFee.fine == 0;

    return Container(
      decoration: isCurrentMonth
          ? BoxDecoration(
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(12),
            )
          : null,
      margin: EdgeInsets.symmetric(vertical: 6),
      child: FilledCard(
        backgroundColor: isOverdue
            ? Colors.yellow.shade400
            : tuitionFee.fine > 0
                ? Colors.red
                : null,
        marginVertical: 0,
        children: [
          Row(
            children: [
              Icon(
                isOverdue
                    ? Icons.warning
                    : tuitionFee.fine > 0
                        ? Icons.dangerous
                        : tuitionFee.debt > 0
                            ? Icons.watch_later
                            : Icons.done,
                color: tuitionFee.fine > 0 ? Colors.white : null,
              ),
              SizedBox(width: 10),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    toBeginningOfSentenceCase(month),
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: tuitionFee.fine > 0 ? Colors.white : null,
                    ),
                  ),
                  if (tuitionFee.debt > 0 || tuitionFee.fine > 0)
                    Text(
                      'Data de vencimento: ${tuitionFee.dueDate}',
                      style: TextStyle(
                        color: tuitionFee.fine > 0 ? Colors.white : null,
                      ),
                    ),
                  if (tuitionFee.amountPaid > 0 && tuitionFee.fine == 0)
                    Text(
                      'Data de pagamento: ${tuitionFee.paymentDate}',
                      style: TextStyle(
                        color: tuitionFee.fine > 0 ? Colors.white : null,
                      ),
                    )
                ],
              )),
              if (tuitionFee.debt > 0)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Valor',
                      style: TextStyle(
                        fontSize: 14,
                        color: tuitionFee.fine > 0 ? Colors.white : null,
                      ),
                    ),
                    Text(
                      '${tuitionFee.debt.toString()}€',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: tuitionFee.fine > 0 ? Colors.white : null,
                      ),
                    )
                  ],
                ),
              if (tuitionFee.amountPaid > 0 && tuitionFee.fine > 0)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Multa',
                      style: TextStyle(
                        fontSize: 14,
                        color: tuitionFee.fine > 0 ? Colors.white : null,
                      ),
                    ),
                    Text(
                      '${tuitionFee.fine.toString()}€',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: tuitionFee.fine > 0 ? Colors.white : null,
                      ),
                    )
                  ],
                ),
              if (tuitionFee.amountPaid > 0 && tuitionFee.fine == 0)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Pago',
                      style: TextStyle(
                        fontSize: 14,
                        color: tuitionFee.fine > 0 ? Colors.white : null,
                      ),
                    ),
                    Text(
                      '${tuitionFee.amountPaid.toString()}€',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: tuitionFee.fine > 0 ? Colors.white : null,
                      ),
                    )
                  ],
                ),
            ],
          )
        ],
      ),
    );
  }
}
