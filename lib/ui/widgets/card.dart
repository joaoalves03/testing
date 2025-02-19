import 'package:flutter/material.dart';

class FilledCard extends StatelessWidget {
  final IconData? icon;
  final String? title;
  final Color? backgroundColor;
  final double? paddingVertical;
  final double? paddingHorizontal;
  final double? marginVertical;
  final double? marginHorizontal;
  final List<Widget> children;
  final Function()? onTap;

  const FilledCard({
    super.key,
    required this.children,
    this.icon,
    this.title,
    this.backgroundColor,
    this.paddingVertical,
    this.paddingHorizontal,
    this.marginVertical,
    this.marginHorizontal,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return Card.filled(
      color: backgroundColor ?? Theme.of(context).colorScheme.surfaceContainer,
      margin: EdgeInsets.symmetric(vertical: marginVertical ?? 6, horizontal: marginHorizontal ?? 0),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: paddingVertical ?? 10, horizontal: paddingHorizontal ?? 10),
          child: Wrap(
            spacing: 4,
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
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold
                        )
                    )
                  ],
                ),

              ...children,
            ]
          )
        ),
      )

    );
  }
}


class ExpandableCard extends StatelessWidget {
  final String title;
  final List<Widget> body;
  final Color? backgroundColor;

  const ExpandableCard({
    super.key,
    required this.title,
    required this.body,
    this.backgroundColor
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Card.filled(
          color: backgroundColor ?? Theme.of(context).colorScheme.surfaceContainer,
          margin: EdgeInsets.symmetric(vertical: 6),
          clipBehavior: Clip.hardEdge,
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              title: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: body,
                    ),
                  ),
                )
              ],
            ),
          )
      ),
    );
  }
}