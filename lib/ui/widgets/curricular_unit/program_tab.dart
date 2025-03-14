import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goipvc/models/curricular_unit.dart';
import 'package:goipvc/providers/data_providers.dart';

import 'package:goipvc/ui/widgets/card.dart';
import 'package:goipvc/ui/widgets/error_message.dart';

class ProgramTab extends ConsumerWidget {
  final PUC puc;

  const ProgramTab({super.key, required this.puc});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Widget> cards = [];

    void card(String title, String? content) {
      if (content != null && content.isNotEmpty) {
        cards.add(ExpandableCard(
          title: title,
          body: [Text(content, style: const TextStyle(fontSize: 16))],
        ));
      }
    }

    card('Resumo', puc.summary);
    card('Objetivos da aprendizagem', puc.objectives);
    card('Conteúdos programáticos', puc.courseContent);
    card('Metodologias de ensino', puc.methodologies);
    card('Avaliação', puc.evaluation);
    card('Bibliografia principal', puc.bibliography);
    card('Bibliografia complementar', puc.bibliographyExtra);


    return RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(curricularUnitProvider);
        },
        child: cards.isEmpty
            ? ErrorMessage(
            icon: Icons.sentiment_dissatisfied,
            message: "Sem programa da Unidade Curricular"
        )
            : ListView(
            padding: const EdgeInsets.all(12),
            children: cards
        )
    );
  }
}