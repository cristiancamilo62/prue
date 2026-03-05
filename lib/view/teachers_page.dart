import 'package:flutter/material.dart';
import '../model/teachers/teacher.dart';
import '../view_model/teachers/teacher_list_view_model.dart';
import 'teacher_subjects_page.dart';

/// Lista de profesores usando los mocks del [TeacherListViewModel].
/// Al tocar "Ver materias" navega a [TeacherSubjectsPage].
class TeachersPage extends StatefulWidget {
  const TeachersPage({super.key});

  @override
  State<TeachersPage> createState() => _TeachersPageState();
}

class _TeachersPageState extends State<TeachersPage> {
  final TeacherListViewModel _viewModel = TeacherListViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final teachers = _viewModel.filteredTeachers;
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        backgroundColor: const Color(0xFF161B22),
        foregroundColor: Colors.white,
        title: const Text('Profesores', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: teachers.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, i) {
          final t = teachers[i];
          return Container(
            decoration: BoxDecoration(
              color: const Color(0xFF161B22),
              border: Border.all(color: const Color(0xFF30363D)),
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: const Color(0xFF4A90D9),
                child: Text(
                  '${t.firstName[0]}${t.lastName[0]}',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              title: Text(t.fullName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
              subtitle: Text(t.department, style: const TextStyle(color: Colors.white54, fontSize: 12)),
              trailing: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF4A90D9),
                  side: const BorderSide(color: Color(0xFF4A90D9)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TeacherSubjectsPage(teacher: t),
                    ),
                  );
                },
                child: const Text('Ver materias', style: TextStyle(fontSize: 12)),
              ),
            ),
          );
        },
      ),
    );
  }
}