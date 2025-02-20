import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goipvc/providers/data_providers.dart';

class ProfilePicture extends ConsumerWidget {
  const ProfilePicture({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studentImageAsync = ref.watch(
      studentImageProvider,
    );

    return CircleAvatar(
      radius: 24,
      backgroundColor: Colors.grey.shade300,
      child: studentImageAsync.when(
        data: (image) => image.isNotEmpty
            ? ClipOval(
          child: Image.memory(
            image,
            fit: BoxFit.cover,
            width: 48,
            height: 48,
            alignment: Alignment.topCenter,
          ),
        )
            : Icon(Icons.person, color: Colors.grey),
        loading: () => CircularProgressIndicator(),
        error: (_, __) =>
            Icon(Icons.error, color: Colors.red),
      ),
    );
  }
}