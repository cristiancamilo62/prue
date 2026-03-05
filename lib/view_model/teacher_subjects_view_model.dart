import 'package:flutter/material.dart';
import '../model/teachers/teacher.dart';
import '../model/subject/subject.dart';
import '../model/subjectteacher/subjectteacher.dart';
import '../data/fake_api.dart';

/// ViewModel para la pantalla principal: vista desde un PROFESOR o desde una MATERIA.
/// - fromTeacherId → muestra materias de ese profesor
/// - fromSubjectId → muestra profesores de esa materia
class TeacherSubjectsViewModel extends ChangeNotifier {
  // Puede recibir uno u otro (el modo cambia toda la lógica de presentación)
  final Teacher? teacher;       // modo: ver desde profesor
  final Subject? subject;       // modo: ver desde materia

  TeacherSubjectsViewModel({this.teacher, this.subject})
      : assert(teacher != null || subject != null,
            'Debe pasarse teacher o subject') {
    _load();
  }

  // ── state ────────────────────────────────────────────────────────────────
  List<SubjectTeacher> links = [];
  bool isLoading = true;
  bool isBusy = false;
  String? errorMessage;

  bool get isTeacherMode => teacher != null;

  String get pageTitle => isTeacherMode
      ? 'Materias de ${teacher!.firstName}'
      : 'Profesores de ${subject!.name}';

  int get totalCredits => links.fold(0, (s, l) => s + l.subjectCredits);

  // ── cargar ───────────────────────────────────────────────────────────────
  Future<void> _load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      links = isTeacherMode
          ? await FakeApi.fetchLinksByTeacher(teacher!.id)
          : await FakeApi.fetchLinksBySubject(subject!.id);
    } catch (_) {
      errorMessage = 'No se pudo cargar la información.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() => _load();

  // ── quitar relacion ──────────────────────────────────────────────────────
  Future<bool> removeLink(SubjectTeacher link) async {
    isBusy = true;
    notifyListeners();
    try {
      await FakeApi.removeLink(link.id);
      links.remove(link);
      errorMessage = null;
      return true;
    } catch (_) {
      errorMessage = 'No se pudo quitar la asignación.';
      return false;
    } finally {
      isBusy = false;
      notifyListeners();
    }
  }
}