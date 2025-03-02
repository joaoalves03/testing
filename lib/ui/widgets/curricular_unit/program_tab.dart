import 'package:flutter/material.dart';
import 'package:goipvc/ui/widgets/card.dart';
import 'package:goipvc/ui/widgets/error_message.dart';

class ProgramTab extends StatelessWidget {
  final Map<String, dynamic>? puc;

  const ProgramTab({super.key, required this.puc});

  @override
  Widget build(BuildContext context) {
    if (puc == null) {
      return const Center(child: Text('No program information available'));
    }

    final List<Widget> cards = [];

    void card(String title, String? content) {
      if (content != null && content.isNotEmpty) {
        cards.add(ExpandableCard(
          title: title,
          body: [Text(content, style: const TextStyle(fontSize: 16))],
        ));
      }
    }

    card('Resumo', puc!['summary']);
    card('Objetivos da aprendizagem', puc!['objectives']);
    card('Conteúdos programáticos', puc!['courseContent']);
    card('Metodologias de ensino', puc!['methodologies']);
    card('Avaliação', puc!['evaluation']);
    card('Bibliografia principal', puc!['bibliography']);
    card('Bibliografia complementar', puc!['bibliographyExtra']);

    return cards.isEmpty
      ? ErrorMessage(
        icon: Icons.sentiment_dissatisfied,
        message: "Sem programa da cadeira"
      )
      : ListView(
        padding: const EdgeInsets.all(12),
        children: cards
      );
  }
}