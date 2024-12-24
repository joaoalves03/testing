import 'package:flutter/material.dart';
import 'package:goipvc/models/meal.dart';
import 'package:goipvc/ui/widgets/home/date_section.dart';


class MealsTab extends StatefulWidget {
  const MealsTab({super.key});

  @override
  MealsTabState createState() => MealsTabState();
}

class MealsTabState extends State<MealsTab> {
  final List<Meal> meals = [
    Meal(
      id: 1,
      meal: "",
      name: "Rojões",
      price: 3,
      type: "Sugestão",
      location: "ESTG",
      available: true
    ),
    Meal(
        id: 2,
        meal: "",
        name: "Rojões",
        price: 3,
        type: "Sugestão",
        location: "ESTG",
        available: true
    ),
    Meal(
        id: 3,
        meal: "",
        name: "Rojões",
        price: 3,
        type: "Sugestão",
        location: "ESTG",
        available: true
    )
  ];

  DateTime now = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day
  );

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: () async {

        },
        child: ListView.builder(
          itemCount: 7,
          itemBuilder: (context, index) {
            DateTime currentDate = now.add(Duration(days: index));

            return Padding(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DateSection(date: currentDate),
                      Wrap(
                        alignment: WrapAlignment.start,
                        children: meals
                            .map((meal) => MealCard(meal: meal))
                            .toList(),
                      ),
                    ]
                )
            );
          },
        )
    );
  }
}

class MealCard extends StatelessWidget {
  final Meal meal;

  const MealCard({
    super.key,
    required this.meal,
  });

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      color: Theme.of(context).colorScheme.surfaceContainer,
      elevation: 0,
      child: SizedBox(
        width: 185,
        height: 120,
        child: Container(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    meal.type,
                    style: TextStyle(fontSize: 14),
                  ),
                  Text(
                    meal.name,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ],
              ),
              FilledButton(
                onPressed: () {},
                child: Text(
                  '${meal.price.toString()} €',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}