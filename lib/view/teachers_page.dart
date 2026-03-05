import 'package:flutter/material.dart';
import '../model/teachers/teacher.dart';
import 'teacher_subjects_page.dart';

/// Dummy TeachersPage — lista de profesores con datos dummy.
/// Al tocar "Ver materias" navega a TeacherSubjectsPage.
class TeachersPage extends StatelessWidget {
  const TeachersPage({super.key});

  static final List<Teacher> _dummyTeachers = [
    Teacher(
      id: 't1',
      firstName: 'Juan Pablo',
      lastName: 'Gómez',
      email: 'jp.gomez@uni.edu',
      phone: '3001234567',
      department: 'Ingeniería de Sistemas',
      specialty: 'Software Engineering',
      createdAt: DateTime(2023, 8, 1),
      updatedAt: DateTime(2024, 1, 10),
    ),
    Teacher(
      id: 't2',
      firstName: 'María',
      lastName: 'López',
      email: 'm.lopez@uni.edu',
      phone: '3107654321',
      department: 'Ingeniería Eléctrica',
      specialty: 'Redes y Telecomunicaciones',
      createdAt: DateTime(2023, 8, 1),
      updatedAt: DateTime(2024, 1, 10),
    ),
    Teacher(
      id: 't3',
      firstName: 'Carlos',
      lastName: 'Restrepo',
      email: 'c.restrepo@uni.edu',
      department: 'Matemáticas',
      specialty: 'Álgebra y Cálculo',
      createdAt: DateTime(2023, 8, 1),
      updatedAt: DateTime(2024, 1, 10),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        backgroundColor: const Color(0xFF161B22),
        foregroundColor: Colors.white,
        title: const Text('Profesores', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _dummyTeachers.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, i) {
          final t = _dummyTeachers[i];
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