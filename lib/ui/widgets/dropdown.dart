import 'package:flutter/material.dart';
import './containers.dart';

class Dropdown<t> extends StatelessWidget {
  final t value;
  final List<DropdownMenuItem<t>>? items;
  final ValueChanged<t?> onChanged;

  const Dropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownContainer(
        child: DropdownButton<t>(
            value: this.value,
            items: this.items,
            elevation: 0,
            dropdownColor: Theme.of(context).colorScheme.surfaceContainer, // Dropdown color
            borderRadius: BorderRadius.circular(10), // Dropdown border radius
            onChanged: this.onChanged,
            underline: Container(),
            isDense: true,
            icon: Icon(Icons.arrow_drop_down_rounded),
            iconSize: 32
        ),
    );
  }
}

