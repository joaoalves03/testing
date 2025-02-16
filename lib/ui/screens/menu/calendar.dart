import 'package:flutter/material.dart';

import '../../widgets/card.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Calendário Académico")),
        body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 6),
            child: ListView(
              children: [
                ExpandableCard(
                  title: "Períodos",
                  body: [
                    Text("1º Semestre:",
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text("16 de setembro a 15 de fevereiro"),
                    const SizedBox(height: 6),
                    Text("2º Semestre:",
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text("17 de fevereiro a 19 de julho"),
                  ],
                ),
                ExpandableCard(
                  title: "Paragem Letiva",
                  body: [
                    CalendarItem(
                      title: "Natal:",
                      body: [
                        Text("23 de dezembro a 04 de janeiro 2025"),
                      ],
                    ),
                    CalendarItem(
                      title: "Carnaval:",
                      body: [
                        Text("03 a 04 de março 2025"),
                      ],
                    ),
                  ],
                ),
                ExpandableCard(
                  title: "Dias Comemorativos",
                  body: [
                    CalendarItem(
                      title: "IPVC:",
                      body: [
                        Text("15 de Maio"),
                      ],
                      row: true,
                    ),
                    CalendarItem(
                      title: "ESE:",
                      body: [
                        Text("9 de Novembro"),
                      ],
                      row: true,
                    ),
                  ],
                )
              ],
            )
        )
    );
  }
}

class CalendarItem extends StatelessWidget {
  final String title;
  final List<Widget> body;
  final bool row;

  const CalendarItem({
    super.key,
    required this.title,
    required this.body,
    this.row = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (row && body.length == 1)
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 4),
              ...body,
            ],
          )
        else
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              ...body,
            ],
          ),

        const SizedBox(height: 6),
      ],
    );
  }
}