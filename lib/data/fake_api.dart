import '../model/teachers/teacher.dart';
import '../model/subject/subject.dart';
import '../model/subjectteacher/subjectteacher.dart';

/// Repositorio fake que simula un backend REST.
/// Cuando tengas el backend real, reemplaza cada método
/// por su llamada HTTP correspondiente.
class FakeApi {
  FakeApi._();

  // ── Datos base ──────────────────────────────────────────────────────────
  static final List<Teacher> _teachers = [
    Teacher(
      id: 'TCH-001',
      firstName: 'Juan',
      lastName: 'Pablo',
      email: 'juan.pablo@uco.edu',
      phone: '809-555-0101',
      age: 25,
      department: 'Systems Engineering',
      specialty: 'Mobile Development',
      subjects: ['Ingeniería de Software 3', 'Ingeniería de Software Avanzada 2'],
      profileImageUrl: 'https://example.com/avatars/juan.jpg',
      isActive: true,
      createdAt: DateTime(2024, 1, 15),
      updatedAt: DateTime(2024, 6, 10),
    ),
    Teacher(
      id: 'TCH-002',
      firstName: 'Maria',
      lastName: 'Lopez',
      email: 'maria.lopez@uco.edu',
      phone: '809-555-0102',
      age: 34,
      department: 'Systems Engineering',
      specialty: 'Artificial Intelligence',
      subjects: ['Fundamentos de IA', 'Aprendizaje Automático'],
      profileImageUrl: 'https://example.com/avatars/maria.jpg',
      isActive: true,
      createdAt: DateTime(2023, 8, 20),
      updatedAt: DateTime(2024, 5, 5),
    ),
    Teacher(
      id: 'TCH-003',
      firstName: 'Carlos',
      lastName: 'Mendez',
      email: 'carlos.mendez@uco.edu',
      phone: '809-555-0103',
      age: 45,
      department: 'Mathematics',
      specialty: 'Exact sciences',
      subjects: ['Cálculo I', 'Álgebra Lineal', 'Estadística'],
      profileImageUrl: 'https://example.com/avatars/carlos.jpg',
      isActive: true,
      createdAt: DateTime(2022, 3, 1),
      updatedAt: DateTime(2024, 4, 18),
    ),
    Teacher(
      id: 'TCH-004',
      firstName: 'Ana',
      lastName: 'Rivera',
      email: 'ana.rivera@uco.edu',
      phone: '809-555-0104',
      age: 39,
      department: 'Systems Engineering',
      specialty: 'Web Development',
      subjects: ['Desarrollo Web', 'Diseño de Bases de Datos'],
      profileImageUrl: 'https://example.com/avatars/ana.jpg',
      isActive: true,
      createdAt: DateTime(2023, 1, 10),
      updatedAt: DateTime(2024, 7, 22),
    ),
  ];

  static final List<Subject> _subjects = [
    Subject(id: 's1', name: 'Ing. Software I', code: 'SW101', credits: 3, description: 'Fundamentos de ingeniería de software', isActive: true, createdAt: DateTime(2024, 1, 10), updatedAt: DateTime(2024, 1, 10)),
    Subject(id: 's2', name: 'Ing. Software II', code: 'SW102', credits: 3, description: 'Arquitecturas y patrones de diseño', isActive: true, createdAt: DateTime(2024, 1, 10), updatedAt: DateTime(2024, 1, 10)),
    Subject(id: 's3', name: 'Base de Datos', code: 'DB201', credits: 4, description: 'Diseño y gestión de BD relacionales', isActive: true, createdAt: DateTime(2024, 1, 10), updatedAt: DateTime(2024, 1, 10)),
    Subject(id: 's4', name: 'Redes', code: 'NET301', credits: 3, description: 'Fundamentos de redes de computadoras', isActive: true, createdAt: DateTime(2024, 1, 10), updatedAt: DateTime(2024, 1, 10)),
    Subject(id: 's5', name: 'Matemáticas Discretas', code: 'MAT101', credits: 4, description: 'Lógica, conjuntos y teoría de grafos', isActive: true, createdAt: DateTime(2024, 1, 10), updatedAt: DateTime(2024, 1, 10)),
  ];

  static final List<SubjectTeacher> _links = [
    SubjectTeacher(id: 'st1', subjectId: 's1', subjectName: 'Ing. Software I', subjectCode: 'SW101', subjectCredits: 3, teacherId: 'TCH-001', teacherName: 'Juan Pablo', teacherEmail: 'juan.pablo@uco.edu', isActive: true, createdAt: DateTime(2024, 2, 1), updatedAt: DateTime(2024, 2, 1)),
    SubjectTeacher(id: 'st2', subjectId: 's2', subjectName: 'Ing. Software II', subjectCode: 'SW102', subjectCredits: 3, teacherId: 'TCH-001', teacherName: 'Juan Pablo', teacherEmail: 'juan.pablo@uco.edu', isActive: true, createdAt: DateTime(2024, 2, 1), updatedAt: DateTime(2024, 2, 1)),
    SubjectTeacher(id: 'st3', subjectId: 's4', subjectName: 'Redes', subjectCode: 'NET301', subjectCredits: 3, teacherId: 'TCH-002', teacherName: 'Maria Lopez', teacherEmail: 'maria.lopez@uco.edu', isActive: true, createdAt: DateTime(2024, 2, 1), updatedAt: DateTime(2024, 2, 1)),
    SubjectTeacher(id: 'st4', subjectId: 's3', subjectName: 'Base de Datos', subjectCode: 'DB201', subjectCredits: 4, teacherId: 'TCH-002', teacherName: 'Maria Lopez', teacherEmail: 'maria.lopez@uco.edu', isActive: true, createdAt: DateTime(2024, 2, 1), updatedAt: DateTime(2024, 2, 1)),
    SubjectTeacher(id: 'st5', subjectId: 's5', subjectName: 'Matemáticas Discretas', subjectCode: 'MAT101', subjectCredits: 4, teacherId: 'TCH-003', teacherName: 'Carlos Mendez', teacherEmail: 'carlos.mendez@uco.edu', isActive: true, createdAt: DateTime(2024, 2, 1), updatedAt: DateTime(2024, 2, 1)),
    SubjectTeacher(id: 'st6', subjectId: 's1', subjectName: 'Ing. Software I', subjectCode: 'SW101', subjectCredits: 3, teacherId: 'TCH-002', teacherName: 'Maria Lopez', teacherEmail: 'maria.lopez@uco.edu', isActive: true, createdAt: DateTime(2024, 3, 1), updatedAt: DateTime(2024, 3, 1)),
  ];

  static Future<void> _delay([int ms = 500]) =>
      Future.delayed(Duration(milliseconds: ms));

  // ── Teachers ────────────────────────────────────────────────────────────
  /// GET /teachers
  static Future<List<Teacher>> fetchTeachers() async {
    await _delay(400);
    return List.from(_teachers);
  }

  /// GET /teachers/:id
  static Future<Teacher?> fetchTeacher(String id) async {
    await _delay(300);
    try { return _teachers.firstWhere((t) => t.id == id); }
    catch (_) { return null; }
  }

  // ── Subjects ─────────────────────────────────────────────────────────────
  /// GET /subjects
  static Future<List<Subject>> fetchSubjects() async {
    await _delay(400);
    return List.from(_subjects);
  }

  /// GET /subjects/:id
  static Future<Subject?> fetchSubject(String id) async {
    await _delay(300);
    try { return _subjects.firstWhere((s) => s.id == id); }
    catch (_) { return null; }
  }

  // ── SubjectTeacher links ─────────────────────────────────────────────────
  /// GET /subject-teachers?teacherId=xxx  → materias de un profesor
  static Future<List<SubjectTeacher>> fetchLinksByTeacher(String teacherId) async {
    await _delay(500);
    return _links.where((l) => l.teacherId == teacherId).toList();
  }

  /// GET /subject-teachers?subjectId=xxx  → profesores de una materia
  static Future<List<SubjectTeacher>> fetchLinksBySubject(String subjectId) async {
    await _delay(500);
    return _links.where((l) => l.subjectId == subjectId).toList();
  }

  /// GET /subject-teachers/:id
  static Future<SubjectTeacher?> fetchLink(String id) async {
    await _delay(300);
    try { return _links.firstWhere((l) => l.id == id); }
    catch (_) { return null; }
  }

  /// POST /subject-teachers  → asignar
  static Future<SubjectTeacher> assignLink(String teacherId, String subjectId) async {
    await _delay(600);
    final teacher = _teachers.firstWhere((t) => t.id == teacherId);
    final subject = _subjects.firstWhere((s) => s.id == subjectId);
    final link = SubjectTeacher(
      id: 'st_${DateTime.now().millisecondsSinceEpoch}',
      subjectId: subjectId,
      subjectName: subject.name,
      subjectCode: subject.code,
      subjectCredits: subject.credits,
      teacherId: teacherId,
      teacherName: teacher.fullName,
      teacherEmail: teacher.email,
      isActive: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _links.add(link);
    return link;
  }

  /// DELETE /subject-teachers/:id  → desasignar
  static Future<void> removeLink(String linkId) async {
    await _delay(500);
    _links.removeWhere((l) => l.id == linkId);
  }

  // helpers internos
  static bool isAssigned(String teacherId, String subjectId) =>
      _links.any((l) => l.teacherId == teacherId && l.subjectId == subjectId);

  static String? linkId(String teacherId, String subjectId) {
    try { return _links.firstWhere((l) => l.teacherId == teacherId && l.subjectId == subjectId).id; }
    catch (_) { return null; }
  }
}