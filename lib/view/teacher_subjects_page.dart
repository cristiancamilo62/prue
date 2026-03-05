import 'package:flutter/material.dart';
import '../model/teachers/teacher.dart';
import '../model/subject/subject.dart';
import '../model/subjectteacher/subjectteacher.dart';
import '../view_model/teacher_subjects_view_model.dart';
import 'assign_subject_teacher_page.dart';

/// Pantalla dual:
///   - Si se pasa [teacher] → muestra materias de ese profesor
///   - Si se pasa [subject] → muestra profesores de esa materia
class TeacherSubjectsPage extends StatefulWidget {
  final Teacher? teacher;
  final Subject? subject;

  const TeacherSubjectsPage({super.key, this.teacher, this.subject})
      : assert(teacher != null || subject != null);

  @override
  State<TeacherSubjectsPage> createState() => _TeacherSubjectsPageState();
}

class _TeacherSubjectsPageState extends State<TeacherSubjectsPage> {
  late final TeacherSubjectsViewModel _vm;

  @override
  void initState() {
    super.initState();
    _vm = TeacherSubjectsViewModel(
      teacher: widget.teacher,
      subject: widget.subject,
    );
    _vm.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _vm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        backgroundColor: const Color(0xFF161B22),
        foregroundColor: Colors.white,
        title: Text(_vm.pageTitle,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _vm.isLoading ? null : _vm.refresh,
          ),
          // Botón "Asignar nueva relación" → va a la pantalla de asignación
          IconButton(
            icon: const Icon(Icons.add_link_rounded),
            tooltip: 'Asignar nueva relación',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const AssignSubjectTeacherPage()),
            ).then((_) => _vm.refresh()),
          ),
        ],
      ),
      body: _vm.isLoading
          ? _buildSkeleton()
          : _vm.errorMessage != null && _vm.links.isEmpty
              ? _buildError()
              : _vm.links.isEmpty
                  ? _buildEmpty()
                  : _buildList(),
    );
  }

  // ── header ────────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    if (_vm.isTeacherMode) {
      final t = widget.teacher!;
      return _InfoHeader(
        avatar: '${t.firstName[0]}${t.lastName[0]}',
        title: t.fullName,
        subtitle: t.email,
        tag: t.department,
        badge1Label: 'Materias',
        badge1Value: '${_vm.links.length}',
        badge2Label: 'Créditos',
        badge2Value: '${_vm.totalCredits}',
      );
    } else {
      final s = widget.subject!;
      return _InfoHeader(
        avatar: s.code.length >= 2 ? s.code.substring(0, 2) : s.code,
        title: s.name,
        subtitle: s.description,
        tag: '${s.credits} créditos • ${s.code}',
        badge1Label: 'Profesores',
        badge1Value: '${_vm.links.length}',
        badge2Label: '',
        badge2Value: '',
      );
    }
  }

  // ── lista ─────────────────────────────────────────────────────────────────
  Widget _buildList() {
    return Column(
      children: [
        _buildHeader(),
        if (_vm.errorMessage != null) _buildErrorBanner(),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: 24),
            itemCount: _vm.links.length,
            itemBuilder: (_, i) {
              final link = _vm.links[i];
              return _vm.isTeacherMode
                  ? _SubjectLinkCard(
                      link: link,
                      isBusy: _vm.isBusy,
                      onRemove: () => _handleRemove(link),
                      onAdjuntos: () => _goToAdjuntos(link),
                    )
                  : _TeacherLinkCard(
                      link: link,
                      isBusy: _vm.isBusy,
                      onRemove: () => _handleRemove(link),
                    );
            },
          ),
        ),
      ],
    );
  }

  // ── acciones ──────────────────────────────────────────────────────────────
  Future<void> _handleRemove(SubjectTeacher link) async {
    final name = _vm.isTeacherMode ? link.subjectName : link.teacherName;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Confirmar', style: TextStyle(color: Colors.white)),
        content: Text('¿Quitar "$name" de esta asignación?',
            style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancelar',
                  style: TextStyle(color: Colors.white54))),
          ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Quitar')),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    final success = await _vm.removeLink(link);
    if (!mounted) return;
    _snack(success ? '🗑  Asignación eliminada' : '❌  ${_vm.errorMessage}',
        isError: !success);
  }

  void _goToAdjuntos(SubjectTeacher link) {
    // Pasa el id de la relación — la pantalla de adjuntos lo usará
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('📎  Ir a Adjuntos — linkId: ${link.id}'),
      backgroundColor: const Color(0xFF1A2C42),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ));
    // TODO: Navigator.push( context, MaterialPageRoute(builder: (_) => AdjuntosPage(linkId: link.id)) );
  }

  void _snack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: isError ? Colors.redAccent : const Color(0xFF1A2C42),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      duration: const Duration(seconds: 2),
    ));
  }

  // ── estados ───────────────────────────────────────────────────────────────
  Widget _buildSkeleton() => ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 4,
        itemBuilder: (_, __) => Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          height: 80,
          decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(10)),
        ),
      );

  Widget _buildError() => Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.wifi_off_rounded, size: 60, color: Colors.white24),
          const SizedBox(height: 12),
          Text(_vm.errorMessage!,
              style: const TextStyle(color: Colors.white54)),
          const SizedBox(height: 16),
          ElevatedButton.icon(
              onPressed: _vm.refresh,
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A90D9))),
        ]),
      );

  Widget _buildEmpty() => Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.link_off_rounded, size: 60, color: Colors.white24),
          const SizedBox(height: 12),
          const Text('No hay asignaciones aún.',
              style: TextStyle(color: Colors.white38)),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const AssignSubjectTeacherPage()),
            ).then((_) => _vm.refresh()),
            icon: const Icon(Icons.add_link_rounded),
            label: const Text('Asignar nueva relación'),
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A90D9)),
          ),
        ]),
      );

  Widget _buildErrorBanner() => Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.redAccent.withOpacity(0.15),
          border:
              Border.all(color: Colors.redAccent.withOpacity(0.4)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(children: [
          const Icon(Icons.error_outline, color: Colors.redAccent, size: 18),
          const SizedBox(width: 8),
          Expanded(
              child: Text(_vm.errorMessage!,
                  style: const TextStyle(
                      color: Colors.redAccent, fontSize: 12))),
        ]),
      );
}

// ── Header info ───────────────────────────────────────────────────────────
class _InfoHeader extends StatelessWidget {
  final String avatar, title, subtitle, tag;
  final String badge1Label, badge1Value, badge2Label, badge2Value;

  const _InfoHeader({
    required this.avatar,
    required this.title,
    required this.subtitle,
    required this.tag,
    required this.badge1Label,
    required this.badge1Value,
    required this.badge2Label,
    required this.badge2Value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2C42),
        border: Border.all(color: const Color(0xFF4A90D9)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(children: [
        CircleAvatar(
          radius: 26,
          backgroundColor: const Color(0xFF4A90D9),
          child: Text(avatar,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15)),
            if (subtitle.isNotEmpty)
              Text(subtitle,
                  style: const TextStyle(color: Colors.white54, fontSize: 11)),
            if (tag.isNotEmpty)
              Text(tag,
                  style: const TextStyle(
                      color: Color(0xFF90CAF9), fontSize: 11)),
          ]),
        ),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          _Badge(label: badge1Label, value: badge1Value),
          if (badge2Label.isNotEmpty) ...[
            const SizedBox(height: 4),
            _Badge(label: badge2Label, value: badge2Value),
          ],
        ]),
      ]),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label, value;
  const _Badge({required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
            color: const Color(0xFF0D1B2A),
            borderRadius: BorderRadius.circular(20)),
        child: RichText(
          text: TextSpan(children: [
            TextSpan(
                text: '$value ',
                style: const TextStyle(
                    color: Color(0xFF4A90D9),
                    fontWeight: FontWeight.bold,
                    fontSize: 13)),
            TextSpan(
                text: label,
                style:
                    const TextStyle(color: Colors.white54, fontSize: 11)),
          ]),
        ),
      );
}

// ── Card: materia (modo profesor) ─────────────────────────────────────────
class _SubjectLinkCard extends StatelessWidget {
  final SubjectTeacher link;
  final bool isBusy;
  final VoidCallback onRemove;
  final VoidCallback onAdjuntos;

  const _SubjectLinkCard({
    required this.link,
    required this.isBusy,
    required this.onRemove,
    required this.onAdjuntos,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF1E3A5F),
        border: Border.all(color: const Color(0xFF4A90D9), width: 1.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: const Color(0xFF4A90D9),
              child: Text(
                link.subjectCode.length >= 2
                    ? link.subjectCode.substring(0, 2)
                    : link.subjectCode,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold),
              ),
            ),
            title: Text(link.subjectName,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600)),
            subtitle: Text(
                '${link.subjectCode}  •  ${link.subjectCredits} créditos',
                style: const TextStyle(
                    color: Color(0xFF90CAF9), fontSize: 12)),
            trailing: isBusy
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2))
                : IconButton(
                    icon: const Icon(Icons.link_off_rounded,
                        color: Colors.redAccent),
                    tooltip: 'Quitar asignación',
                    onPressed: onRemove,
                  ),
          ),
          // Fila de acciones
          Padding(
            padding:
                const EdgeInsets.only(left: 16, right: 16, bottom: 10),
            child: Row(children: [
              // Botón Adjuntos — pasa el linkId a la siguiente vista
              OutlinedButton.icon(
                onPressed: isBusy ? null : onAdjuntos,
                icon: const Icon(Icons.attach_file_rounded, size: 16),
                label: Text('Adjuntos  (id: ${link.id})',
                    style: const TextStyle(fontSize: 11)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF90CAF9),
                  side: const BorderSide(color: Color(0xFF4A90D9)),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 6),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6)),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

// ── Card: profesor (modo materia) ─────────────────────────────────────────
class _TeacherLinkCard extends StatelessWidget {
  final SubjectTeacher link;
  final bool isBusy;
  final VoidCallback onRemove;

  const _TeacherLinkCard({
    required this.link,
    required this.isBusy,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final initials = link.teacherName.trim().split(' ').length >= 2
        ? '${link.teacherName.split(' ')[0][0]}${link.teacherName.split(' ')[1][0]}'
        : link.teacherName.substring(0, 2);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2C42),
        border: Border.all(color: const Color(0xFF4A90D9), width: 1.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF4A90D9),
          child: Text(initials.toUpperCase(),
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        title: Text(link.teacherName,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600)),
        subtitle: Text(link.teacherEmail,
            style: const TextStyle(
                color: Color(0xFF90CAF9), fontSize: 12)),
        trailing: isBusy
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2))
            : IconButton(
                icon: const Icon(Icons.link_off_rounded,
                    color: Colors.redAccent),
                tooltip: 'Quitar asignación',
                onPressed: onRemove,
              ),
      ),
    );
  }
}