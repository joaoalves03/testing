import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goipvc/ui/widgets/error_message.dart';
import 'package:goipvc/ui/widgets/profile_picture.dart';
import 'package:goipvc/providers/data_providers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studentInfoAsync = ref.watch(studentInfoProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(studentInfoProvider);
          ref.invalidate(studentImageProvider);
        },
        child: studentInfoAsync.when(
          data: (info) => ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: [
                    ProfilePicture(
                      size: 100,
                    ),
                    Text(
                      info.fullName,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '#${info.studentId}',
                      style: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).colorScheme.onSurfaceVariant
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Divider(),
              ),
              ListTile(
                leading: Icon(Icons.email),
                title: Text('Email'),
                subtitle: Text(info.email),
              ),
              ListTile(
                leading: Icon(Icons.school),
                title: Text('Curso'),
                subtitle: Text(info.course),
              ),
              ListTile(
                leading: Icon(Icons.apartment),
                title: Text('Escola'),
                subtitle: Text(info.schoolName),
              ),
            ],
          ),
          loading: () => Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, stackTrace) => ErrorMessage(
            error: error.toString(),
            stackTrace: stackTrace.toString(),
            callback: () async {
              ref.invalidate(studentInfoProvider);
              ref.invalidate(studentImageProvider);
            }
          )
        ),
      )
    );
  }
}