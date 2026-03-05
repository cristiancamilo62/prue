import 'package:flutter/material.dart';
import '../model/teachers/teacher.dart';
import '../model/subject/subject.dart';
import '../data/fake_api.dart';

/// ViewModel para la pantalla de asignación:
/// Lista todos los profesores con sus materias asignadas/no asignadas
/// y permite asignar/desasignar desde ahí.
class AssignSubjectTeacherViewModel extends ChangeNotifier {
  AssignSubjectTeacherViewModel() {
    _load();
  }

  // ── state ────────────────────────────────────────────────────────────────
  List<Teacher> teachers = [];
  List<Subject> subjects = [];
  /// linkId por clave "teacherId_subjectId"
  final Map<String, String?> _linkMap = {};

  bool isLoading = true;
  String? busyKey;   // "teacherId_subjectId" en proceso
  String? errorMessage;

  String _searchTeacher = '';
  String _searchSubject = '';
  String? _selectedTeacherId;

  String get searchTeacher => _searchTeacher;
  String get searchSubject => _searchSubject;
  String? get selectedTeacherId => _selectedTeacherId;

  Teacher? get selectedTeacher =>
      _selectedTeacherId == null ? null
      : teachers.firstWhere((t) => t.id == _selectedTeacherId, orElse: () => teachers.first);

  List<Teacher> get filteredTeachers {
    if (_searchTeacher.isEmpty) return teachers;
    final q = _searchTeacher.toLowerCase();
    return teachers.where((t) =>
        t.fullName.toLowerCase().contains(q) ||
        t.email.toLowerCase().contains(q)).toList();
  }

  List<Subject> get filteredSubjects {
    if (_searchSubject.isEmpty) return subjects;
    final q = _searchSubject.toLowerCase();
    return subjects.where((s) =>
        s.name.toLowerCase().contains(q) ||
        s.code.toLowerCase().contains(q)).toList();
  }

  bool isAssigned(String teacherId, String subjectId) =>
      _linkMap['${teacherId}_$subjectId'] != null;

  String? getLinkId(String teacherId, String subjectId) =>
      _linkMap['${teacherId}_$subjectId'];

  // ── cargar ───────────────────────────────────────────────────────────────
  Future<void> _load() async {
    isLoading = true;
    notifyListeners();
    try {
      final results = await Future.wait([
        FakeApi.fetchTeachers(),
        FakeApi.fetchSubjects(),
      ]);
      teachers = results[0] as List<Teacher>;
      subjects = results[1] as List<Subject>;
      if (teachers.isNotEmpty) _selectedTeacherId = teachers.first.id;
      await _loadLinks();
    } catch (_) {
      errorMessage = 'No se pudo cargar los datos.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadLinks() async {
    _linkMap.clear();
    for (final t in teachers) {
      final links = await FakeApi.fetchLinksByTeacher(t.id);
      for (final l in links) {
        _linkMap['${t.id}_${l.subjectId}'] = l.id;
      }
    }
  }

  void selectTeacher(String teacherId) {
    _selectedTeacherId = teacherId;
    _searchSubject = '';
    notifyListeners();
  }

  void setSearchTeacher(String q) { _searchTeacher = q; notifyListeners(); }
  void setSearchSubject(String q) { _searchSubject = q; notifyListeners(); }

  // ── asignar / quitar ─────────────────────────────────────────────────────
  Future<bool> toggle(String teacherId, String subjectId) async {
    final key = '${teacherId}_$subjectId';
    busyKey = key;
    notifyListeners();
    try {
      if (isAssigned(teacherId, subjectId)) {
        final id = _linkMap[key]!;
        await FakeApi.removeLink(id);
        _linkMap[key] = null;
      } else {
        final link = await FakeApi.assignLink(teacherId, subjectId);
        _linkMap[key] = link.id;
      }
      errorMessage = null;
      return true;
    } catch (_) {
      errorMessage = 'Error al actualizar la asignación.';
      return false;
    } finally {
      busyKey = null;
      notifyListeners();
    }
  }
}