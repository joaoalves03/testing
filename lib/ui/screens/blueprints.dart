import 'package:flutter/material.dart';
import 'package:goipvc/models/blueprint.dart';
import 'package:photo_view/photo_view.dart';

class BlueprintScreen extends StatefulWidget {
  const BlueprintScreen({super.key});

  @override
  State<BlueprintScreen> createState() => _BlueprintScreenState();
}

class _BlueprintScreenState extends State<BlueprintScreen> {
  late String _currentSchool;
  late int _currentIndex;
  final DraggableScrollableController _sheetController = DraggableScrollableController();
  final List<Blueprint> blueprints = [
    Blueprint(
      index: 1,
      imageUrl: "https://picsum.photos/seed/1/1280/768",
      legend: {
        "SE": "Saída de Emergência",
        "S": "Sala de Aula",
        "L": "Laboratório",
      },
    ),
    Blueprint(
      index: 2,
      imageUrl: "https://picsum.photos/seed/2/1280/768",
      legend: {
        "AE": "Associação de Estudantes",
        "WC": "Casas de Banho",
        "BL": "Biblioteca",
      },
    ),
    Blueprint(
      index: 3,
      imageUrl: "https://picsum.photos/seed/3/1280/768",
      legend: {
        "SE": "Saída de Emergência",
        "S": "Sala de Aula",
        "L": "Laboratório",
      },
    ),
  ];

  @override
  void initState() {
    super.initState();
    _currentSchool = "ESTG";
    _currentIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    final currentBlueprint = blueprints[_currentIndex];

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              PhotoView.customChild(
                backgroundDecoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface
                ),
                minScale: 1.0,
                maxScale: 10.0,
                child: Center(
                  child: Image.network(
                    currentBlueprint.imageUrl,
                    fit: BoxFit.contain,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                ),
              ),

              DraggableScrollableSheet(
                controller: _sheetController,
                initialChildSize: 0.1,
                minChildSize: 0.1,
                maxChildSize: 0.8,
                snap: true,
                snapSizes: [0.1, 0.5, 0.8],
                builder: (context, scrollController) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainer,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
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
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Legenda - ${_currentSchool} Piso ${currentBlueprint.index}',
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 16),
                              ...currentBlueprint.legend.entries.map(
                                  (entry) => LegendItem(
                                      abbreviation: entry.key,
                                      description: entry.value
                                  ),
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
                      clipBehavior: Clip.antiAlias,
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Column(
                            verticalDirection: VerticalDirection.up,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              for(var (index, blueprint) in blueprints.indexed)
                                FloorSelector(
                                  active: _currentIndex == index,
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
                                  onTap: () => setState(() => _currentIndex = index),
                                ),
                            ],
                          ),
                          Container(
                            height: 20,
                            alignment: Alignment.center,
                            child: Container(
                              width: 32,
                              height: 2,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surfaceDim,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                          FloorSelector(
                            active: false,
                            child: Icon(Icons.swap_horiz),
                            onTap: () => setState(() => _currentIndex = 0),
                          )
                        ],
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

class LegendItem extends StatelessWidget{
  final String abbreviation;
  final String description;

  const LegendItem({
    super.key,
    required this.abbreviation,
    required this.description
  });

  @override
  Widget build(BuildContext context) {
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
}

class FloorSelector extends StatelessWidget{
  final Widget child;
  final bool active;
  final void Function() onTap;

  const FloorSelector({
    super.key,
    required this.child,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: active
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.surfaceContainer,
        child: InkWell(
          onTap: onTap,
          child: Center(
            child: child,
          ),
        ),
      ),
    );
  }
}