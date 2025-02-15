import 'package:flutter/material.dart';
import 'package:goipvc/models/blueprint.dart';

import '../widgets/dropdown.dart';

class BlueprintScreen extends StatefulWidget {
  const BlueprintScreen({super.key});

  @override
  State<BlueprintScreen> createState() => _BlueprintScreenState();
}

class _BlueprintScreenState extends State<BlueprintScreen> {
  late int _currentIndex;
  final TransformationController _transformationController = TransformationController();
  final DraggableScrollableController _sheetController = DraggableScrollableController();
  final List<Blueprint> blueprints = [
    Blueprint(
      index: 1,
      school: "ESTG",
      imageUrl: "https://picsum.photos/seed/1/1280/768",
      legend: {
        "SE": "Saída de Emergência",
        "S": "Sala de Aula",
        "L": "Laboratório",
      },
    ),
    Blueprint(
      index: 3,
      school: "ESTG",
      imageUrl: "https://picsum.photos/seed/3/1280/768",
      legend: {
        "SE": "Saída de Emergência",
        "S": "Sala de Aula",
        "L": "Laboratório",
      },
    ),
    Blueprint(
      index: 2,
      school: "ESTG",
      imageUrl: "https://picsum.photos/seed/2/1280/768",
      legend: {
        "AE": "Associação de Estudantes",
        "WC": "Casas de Banho",
        "BL": "Biblioteca",
      },
    ),
  ]..sort((a, b) => a.index.compareTo(b.index));

  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
  }

  Widget _buildLegendItem(String abbreviation, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(
              child: Text(
                abbreviation,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentBlueprint = blueprints[_currentIndex];

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              InteractiveViewer(
                transformationController: _transformationController,
                boundaryMargin: const EdgeInsets.all(double.infinity),
                minScale: 1,
                maxScale: 10.0,
                child: Center(
                  child: Image.network(
                    currentBlueprint.imageUrl,
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              Positioned(
                left: 6,
                top: 6,
                child: Dropdown<String>(
                  value: "ESTG",
                  items: [
                    DropdownMenuItem(
                        value: "ESTG",
                        child: Text(
                            "ESTG",
                          style: TextStyle(fontSize: 18),
                        )
                    ),
                    DropdownMenuItem(
                        value: "ESA",
                        child: Text(
                          "ESA",
                          style: TextStyle(fontSize: 18),
                        )
                    ),
                    DropdownMenuItem(
                        value: "ESCE",
                        child: Text(
                          "ESCE",
                          style: TextStyle(fontSize: 18),
                        )
                    ),
                  ],
                  onChanged: (Object? value) {  },
                ),
              ),

              DraggableScrollableSheet(
                controller: _sheetController,
                initialChildSize: 0.1,
                minChildSize: 0.1,
                maxChildSize: 0.8,
                snap: true,
                snapSizes: const [0.1, 0.5, 0.8],
                builder: (context, scrollController) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
                          blurRadius: 16,
                        ),
                      ],
                    ),
                    child: ListView(
                      controller: scrollController,
                      children: [
                        Container(
                          height: 24,
                          alignment: Alignment.center,
                          child: Container(
                            width: 48,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.outline,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Legenda - Piso ${currentBlueprint.index}',
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 16),
                              ...currentBlueprint.legend.entries.map(
                                    (entry) => _buildLegendItem(entry.key, entry.value),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              ListenableBuilder(
                listenable: _sheetController,
                builder: (context, child) {
                  final sheetHeight = constraints.maxHeight *
                      (_sheetController.isAttached ? _sheetController.size : 0.1);
                  return Positioned(
                    left: 16,
                    bottom: sheetHeight + 16,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceContainer,
                        borderRadius: BorderRadius.circular(100),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).colorScheme.shadow.withOpacity(0.2),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      clipBehavior: Clip.hardEdge,
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        verticalDirection: VerticalDirection.up,
                        mainAxisSize: MainAxisSize.min,
                        children: blueprints.asMap().entries.map((entry) {
                          final index = entry.key;
                          final blueprint = entry.value;
                          return Container(
                            width: 42,
                            height: 42,
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            decoration: BoxDecoration(
                              color: _currentIndex == index
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.surfaceContainer,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(100),
                              onTap: () => setState(() => _currentIndex = index),
                              child: Center(
                                child: Text(
                                  "${blueprint.index}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: _currentIndex == index
                                        ? Theme.of(context).colorScheme.onPrimary
                                        : Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        }
      )
    );
  }
}