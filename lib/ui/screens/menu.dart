import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goipvc/providers/data_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:goipvc/ui/screens/menu/tuition_fees.dart';
import 'package:goipvc/ui/screens/menu/calendar.dart';
import 'package:goipvc/ui/screens/menu/profile.dart';
import 'package:goipvc/ui/screens/menu/settings.dart';
import 'package:goipvc/ui/widgets/list_section.dart';

class MenuScreen extends ConsumerWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            child: UserCard(),
          ),
          ListSection(title: "Geral", children: [
            ListTile(
              leading: const Icon(Icons.school),
              title: const Text("Cadeiras"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.calendar_month),
              title: const Text("Calendário Académico"),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CalendarScreen())),
            ),
            const ListTile(
              leading: Icon(Icons.people),
              title: Text("Corpo Docente"),
            ),
            const ListTile(
              leading: Icon(Icons.watch_later),
              title: Text("Horário de Serviços"),
            )
          ]),
          ListSection(title: "Académicos", children: [
            ListTile(
              leading: Image.asset(
                'assets/logos/services/academicos.png',
                width: 20,
                height: 20,
              ),
              title: const Text("Académicos"),
              trailing: const Icon(Icons.launch),
            ),
            ListTile(
              leading: const Icon(Icons.local_atm),
              title: const Text("Propinas"),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const TuitionFeesScreen())),
            ),
            const ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text("Exames"),
            )
          ]),
          ListSection(title: "SASocial", children: [
            ListTile(
              leading: Image.asset(
                'assets/logos/services/sasocial.png',
                width: 20,
                height: 20,
              ),
              title: const Text("SASocial"),
              trailing: const Icon(Icons.launch),
            ),
            const ListTile(
              leading: Icon(Icons.credit_card),
              title: Text("Conta"),
            )
          ]),
          ListSection(title: "ON", children: [
            ListTile(
              leading: Image.asset(
                'assets/logos/services/on.png',
                width: 20,
                height: 20,
              ),
              title: const Text("ON"),
              trailing: const Icon(Icons.launch),
            )
          ]),
          ListSection(title: "Moodle", children: [
            ListTile(
              leading: Image.asset(
                'assets/logos/services/moodle.png',
                width: 20,
                height: 20,
              ),
              title: const Text("Moodle"),
              trailing: const Icon(Icons.launch),
            )
          ]),
          const Divider(),
          ListSection(children: [
            const ListTile(
              leading: Icon(Icons.info),
              title: Text("Sobre"),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Definições"),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SettingsScreen())),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () async {
                final prefs = await SharedPreferences.getInstance();
                final serverUrl = prefs.getString('server_url');
                await prefs.clear();
                if (serverUrl != null) {
                  await prefs.setString('server_url', serverUrl);
                }
                if (context.mounted) {
                  Navigator.pushReplacementNamed(context, '/login');
                }
              },
            ),
            const SizedBox(height: 60),
          ])
        ],
      ),
    );
  }
}

class UserCard extends ConsumerWidget {
  const UserCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studentInfoAsync = ref.watch(studentInfoProvider);

    return GestureDetector(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (context) => const ProfileScreen())),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            studentInfoAsync.when(
              data: (info) {
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
                            ),
                          )
                        : const Icon(Icons.person, color: Colors.grey),
                    loading: () => const CircularProgressIndicator(),
                    error: (_, __) =>
                        const Icon(Icons.error, color: Colors.red),
                  ),
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (_, __) => const Icon(Icons.error, color: Colors.red),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: studentInfoAsync.when(
                data: (info) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      info.fullName,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text('${info.courseInitials} - ${info.schoolInitials}',
                        style: const TextStyle(fontSize: 14)),
                    Text('Nº ${info.studentId}',
                        style: const TextStyle(fontSize: 14)),
                  ],
                ),
                loading: () => const CircularProgressIndicator(),
                error: (_, __) => const Text('Erro ao carregar informações'),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
