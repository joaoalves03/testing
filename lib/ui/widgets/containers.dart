import 'package:flutter/material.dart';

class DropdownContainer extends StatelessWidget {
  final Widget child;

  const DropdownContainer({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.only(
          start: 10,
          end: 1,
          top: 6,
          bottom: 6
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadiusDirectional.circular(10),
      ),
      child: child
    );
  }
}

class TextContainer extends StatelessWidget {
  final String text;

  const TextContainer({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsetsDirectional.only(
            start: 16,
            end: 16,
            top: 10,
            bottom: 10
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainer,
          borderRadius: BorderRadiusDirectional.circular(10),
        ),
        child: Text(text)
    );
  }
}