import 'package:flutter/material.dart';
import 'package:goipvc/ui/screens/menu/calendar.dart';
import 'package:goipvc/ui/screens/menu/profile.dart';
import 'package:goipvc/ui/screens/menu/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:goipvc/ui/widgets/list_section.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            child: UserCard(),
          ),
          ListSection(title: "Geral", children: [
            ListTile(
              leading: Icon(Icons.school),
              title: Text("Cadeiras"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.calendar_month),
              title: Text("Calendário Académico"),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CalendarScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.people),
              title: Text("Corpo Docente"),
            ),
            ListTile(
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
              title: Text("Académicos"),
              trailing: Icon(Icons.launch),
            ),
            ListTile(
              leading: Icon(Icons.local_atm),
              title: Text("Propinas"),
            ),
            ListTile(
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
              title: Text("SASocial"),
              trailing: Icon(Icons.launch),
            ),
            ListTile(
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
              title: Text("ON"),
              trailing: Icon(Icons.launch),
            )
          ]),
          ListSection(title: "Moodle", children: [
            ListTile(
              leading: Image.asset(
                'assets/logos/services/moodle.png',
                width: 20,
                height: 20,
              ),
              title: Text("Moodle"),
              trailing: Icon(Icons.launch),
            )
          ]),
          Divider(),
          ListSection(children: [
            ListTile(
              leading: Icon(Icons.info),
              title: Text("Sobre"),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Definições"),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingsScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Logout"),
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                String? serverUrl = prefs.getString('server_url');
                await prefs.clear();
                await prefs.setString('server_url', serverUrl!);
                if (context.mounted) {
                  Navigator.pushReplacementNamed(context, '/login');
                }
              },
            ),
            SizedBox(height: 60)
          ])
        ],
      ),
    );
  }
}

class UserCard extends StatelessWidget {
  const UserCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ProfileScreen()))
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.grey.shade300,
              child: const Icon(Icons.person, color: Colors.grey),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'John Doe',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text('EI - ESTG', style: TextStyle(fontSize: 14)),
                  Text('Nº XXXXX', style: TextStyle(fontSize: 14)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
