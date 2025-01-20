import 'package:flutter/material.dart';
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
          ListSection(title: "SASocial", children: [
            ListTile(
              leading: Icon(Icons.credit_card),
              title: Text("Conta"),
            )
          ]),
          ListSection(title: "Academicos", children: [
            ListTile(
              leading: Icon(Icons.payment),
              title: Text("Propinas"),
            ),
            ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text("Exames"),
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
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Logout"),
              onTap: () async {
                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                await prefs.remove('isLoggedIn');
                if (context.mounted) {
                  Navigator.pushReplacementNamed(context, '/login');
                }
              },
            ),
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
      onTap: () => ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('to be implemented')),
      ),
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
