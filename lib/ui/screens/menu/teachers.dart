import 'package:flutter/material.dart';
import 'package:goipvc/models/teacher.dart';

class TeachersScreen extends StatefulWidget {
  const TeachersScreen({super.key});

  @override
  TeachersScreenState createState() => TeachersScreenState();
}

class TeachersScreenState extends State<TeachersScreen> {
  // TODO: Placeholder data for teachers
  final List<Teacher> teachers = [
    Teacher(
      name: 'Professor João Silva',
      email: 'joao.silva@ipvc.pt',
    ),
    Teacher(
      name: 'Professor Maria Santos',
      email: 'maria@ipvc.pt',
    ),
    Teacher(
      name: 'Professor Carlos Mendes',
      email: 'carlos@ipvc.pt',
    ),
  ];

  List<Teacher> _filteredTeachers = [];

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredTeachers = List.from(teachers);
    _searchController.addListener(_filterTeachers);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterTeachers() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredTeachers = teachers
          .where((teacher) => teacher.name.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Corpo Docente"),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Pesquisar docente...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          // List of teachers
          Expanded(
            child: ListView.builder(
              itemCount: _filteredTeachers.length,
              itemBuilder: (context, index) {
                final teacher = _filteredTeachers[index];
                return ListTile(
                  title: Text(teacher.name),
                  subtitle: Text(teacher.email),
                  leading: Icon(Icons.person),
                  onTap: () {
                    // TODO: Missing Navigation
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
