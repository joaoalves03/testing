import 'package:flutter/material.dart';
import 'package:goipvc/ui/widgets/dropdown.dart';
import 'package:goipvc/ui/widgets/list_section.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: ListView(
        children: <Widget>[
          ListSection(title: "Aparência", children: [
            ListTile(
              leading: Icon(Icons.palette),
              title: Text("Esquema de Cores"),
              trailing: Dropdown<String>(
                value: "system",
                items: [
                  DropdownMenuItem<String>(
                    value: "system",
                    child: Text("Sistema"),
                  ),
                  DropdownMenuItem<String>(
                    value: "school",
                    child: Text("Escola"),
                  ),
                  DropdownMenuItem<String>(
                    value: "normal",
                    child: Text("Normal"),
                  ),
                ],
                onChanged: (String? value) {  },
              ),
            ),
            ListTile(
              leading: Icon(Icons.brightness_medium),
              title: Text("Tema"),
              trailing: Dropdown<String>(
                value: "system",
                items: [
                  DropdownMenuItem<String>(
                    value: "system",
                    child: Text("Sistema"),
                  ),
                  DropdownMenuItem<String>(
                    value: "dark",
                    child: Text("Escuro"),
                  ),
                  DropdownMenuItem<String>(
                    value: "light",
                    child: Text("Claro"),
                  ),
                ],
                onChanged: (String? value) {  },
              ),
            ),
          ]),
          Divider(),
        ],
      ),
    );
  }
}