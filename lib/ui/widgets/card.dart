import 'package:flutter/material.dart';

class FilledCard extends StatelessWidget {
  final IconData? icon;
  final String? title;
  final List<Widget> children;

  const FilledCard({
    super.key,
    required this.children,
    this.icon,
    this.title,
  });

  @override
  Widget build(BuildContext context) {

    return Card.filled(
        color: Theme.of(context).colorScheme.surfaceContainer,
        margin: const EdgeInsets.symmetric(vertical: 6),
        child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 10),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if(title != null && title!.isNotEmpty)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 6),
                          child: Icon(
                            icon,
                            size: 16,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),

                        Text(
                            title!,
                            style: TextStyle(
                                fontSize: 20.0,
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold
                            )
                        )
                      ],
                    ),

                  ...children
                ]
            )
        )
    );
  }
}
