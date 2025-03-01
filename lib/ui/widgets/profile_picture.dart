import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goipvc/providers/data_providers.dart';

class ProfilePicture extends ConsumerWidget {
  final double size;

  const ProfilePicture({super.key, this.size = 48});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studentImageAsync = ref.watch(studentImageProvider);

    return CircleAvatar(
      radius: size / 2,
      backgroundColor: Colors.transparent,
      child: studentImageAsync.when(
        data: (image) => image.isNotEmpty
            ? ClipOval(
              child: Image.memory(
                image,
                fit: BoxFit.cover,
                width: size,
                height: size,
                alignment: Alignment.topCenter,
              ),
            )
            : DefaultPicture(size: size),
        loading: () => CircularProgressIndicator(),
        error: (_, __) => DefaultPicture(size: size),
      ),
    );
  }
}

class DefaultPicture extends StatelessWidget {
  final double size;
  final IconData icon;

  const DefaultPicture({
    super.key,
    required this.size,
    this.icon = Icons.account_circle
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      size: size,
      color: Theme.of(context).colorScheme.onSurfaceVariant,
    );
  }
}