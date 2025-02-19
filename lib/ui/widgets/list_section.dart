import 'package:flutter/material.dart';

class ListSection extends StatelessWidget {
  final String? title;
  final List<Widget> children;

  const ListSection({super.key, this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              title!,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ...children, // Spread the children widgets correctly
      ],
    );
  }
}
