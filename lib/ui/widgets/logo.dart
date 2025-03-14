import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Logo extends StatelessWidget {
  final double size;
  final String? text;

  const Logo({super.key, this.size = 64, this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          'assets/logo.svg',
          height: size,
          colorFilter: ColorFilter.mode(
            Theme.of(context).colorScheme.onSurface,
            BlendMode.srcIn,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 6),
          child: Text(
            text ?? "goIPVC não é um projeto oficial do IPVC",
            style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: size / 4),
          ),
        )
      ],
    );
  }
}
