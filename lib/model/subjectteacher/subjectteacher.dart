class SubjectTeacher {
  final String id;
  final String subjectId;
  final String subjectName;
  final String subjectCode;
  final int subjectCredits;
  final String teacherId;
  final String teacherName;
  final String teacherEmail;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SubjectTeacher({
    required this.id,
    required this.subjectId,
    this.subjectName = '',
    this.subjectCode = '',
    this.subjectCredits = 0,
    required this.teacherId,
    this.teacherName = '',
    this.teacherEmail = '',
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SubjectTeacher.fromJson(Map<String, dynamic> json) {
    return SubjectTeacher(
      id: json['id'] as String,
      subjectId: json['subject_id'] as String,
      subjectName: json['subject_name'] as String? ?? '',
      subjectCode: json['subject_code'] as String? ?? '',
      subjectCredits: json['subject_credits'] as int? ?? 0,
      teacherId: json['teacher_id'] as String,
      teacherName: json['teacher_name'] as String? ?? '',
      teacherEmail: json['teacher_email'] as String? ?? '',
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'subject_id': subjectId,
        'subject_name': subjectName,
        'subject_code': subjectCode,
        'subject_credits': subjectCredits,
        'teacher_id': teacherId,
        'teacher_name': teacherName,
        'teacher_email': teacherEmail,
        'is_active': isActive,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is SubjectTeacher && other.id == id;

  @override
  int get hashCode => id.hashCode;
}