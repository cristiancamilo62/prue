import 'package:flutter/material.dart';
// import 'package:ubook_app/model/subject/subject.dart';
// import 'model/teachers/teacher.dart';
// import 'view/teacher_subjects_page.dart';
import 'view/teachers/teacher_list_view.dart';
import 'view/teachers/teacher_form_view.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Teacher quemado para pruebas
  // static final Teacher _teacher = Teacher(
  //   id: 't1',
  //   firstName: 'Juan Pablo',
  //   lastName: 'Gómez',
  //   email: 'jp.gomez@uni.edu',
  //   phone: '3001234567',
  //   department: 'Ingeniería de Sistemas',
  //   specialty: 'Software Engineering',
  //   createdAt: DateTime(2023, 8, 1),
  //   updatedAt: DateTime(2024, 1, 10),
  // );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      routes: {
        '/teacher-form': (context) => const TeacherFormView(),
      },
      // Para probar modo PROFESOR:
      // home: TeacherSubjectsPage(teacher: _teacher),
      // Para probar modo MATERIA:
      // home: TeacherSubjectsPage(subject: Subject(id:'s1', name:'Ing. Software I', code:'SW101', credits:3, createdAt:DateTime.now(), updatedAt:DateTime.now())),
      home: const TeacherListView(),
    );
  }
}