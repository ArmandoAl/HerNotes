import 'package:her_notes/Domain/models/notes_model.dart';
import 'package:her_notes/Presentation/provider/doctor_provider.dart';
import 'package:her_notes/Presentation/provider/notes_provider.dart';
import 'package:her_notes/Presentation/provider/user_provider.dart';
import 'package:her_notes/Presentation/screens/anotationsScreen.dart';
import 'package:her_notes/Presentation/screens/main_shell.dart';
import 'package:her_notes/Presentation/screens/newTaskScreen.dart';
import 'package:her_notes/Presentation/screens/noteScreen.dart';
import 'package:her_notes/Config/utils/theme_provider.dart';
import 'package:her_notes/Presentation/widgets/app_message.dart';
import 'package:her_notes/Presentation/widgets/empty_state.dart';
import 'package:her_notes/Presentation/widgets/haven_button.dart';
import 'package:her_notes/Presentation/widgets/haven_loader.dart';
import 'package:her_notes/Presentation/widgets/journal_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DiarioView extends StatefulWidget {
  final int userId;
  const DiarioView({Key? key, required this.userId}) : super(key: key);

  @override
  State<DiarioView> createState() => _DiarioViewState();
}

class _DiarioViewState extends State<DiarioView> {
  void _openWriter({
    required NotesProvider notesProvider,
    int? taskId,
    String? taskTitle,
    String? taskContent,
  }) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return WriteNotePage(
            userId: widget.userId,
            notesProvider: notesProvider,
            taskId: taskId,
            taskTitle: taskTitle,
            taskContent: taskContent,
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.08),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            )),
            child: FadeTransition(opacity: animation, child: child),
          );
        },
      ),
    );
  }

  Map<String, List<NotesModel>> _groupNotes(List<NotesModel> notes) {
    final grouped = <String, List<NotesModel>>{};
    final now = DateTime.now();
    for (final note in notes) {
      final date = note.fecha?.toLocal() ?? now;
      String label;
      if (_isSameDay(date, now)) {
        label = 'Hoy';
      } else if (_isSameDay(date, now.subtract(const Duration(days: 1)))) {
        label = 'Ayer';
      } else {
        label = DateFormat("EEEE d 'de' MMMM", 'es').format(date);
        label = label[0].toUpperCase() + label.substring(1);
      }
      grouped.putIfAbsent(label, () => []).add(note);
    }
    return grouped;
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final notesProvider = Provider.of<NotesProvider>(context);
    final palette = havenPalette(context);
    final isDoctor = userProvider.user!.usertype == 'doctor';
    String subjectName = firstNameOf(userProvider.user!.user.name);
    if (isDoctor) {
      final doctorProvider = Provider.of<DoctorProvider>(context);
      final match = doctorProvider.doctor?.pacientes
          ?.where((paciente) => paciente.id == widget.userId);
      if (match != null && match.isNotEmpty) {
        subjectName = firstNameOf(match.first.name);
      }
    }

    if (notesProvider.loading) {
      return const HavenLoader(message: 'Abriendo tu diario...');
    }

    final grouped = _groupNotes(notesProvider.notes);
    final bottomInset = isDoctor ? 24.0 : 118.0;

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: isDoctor ? 8 : 72),
        child: isDoctor
            ? FloatingActionButton.extended(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          WriteNewTask(pacienteId: widget.userId),
                    ),
                  );
                },
                icon: const Icon(Icons.auto_stories_rounded),
                label: const Text('Dejar ejercicio'),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (notesProvider.tasks.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FloatingActionButton.extended(
                        heroTag: 'task-fab',
                        backgroundColor: palette.accent,
                        onPressed: () {
                          _openWriter(
                            notesProvider: notesProvider,
                            taskId: notesProvider.tasks[0].id,
                            taskTitle: notesProvider.tasks[0].title,
                            taskContent: notesProvider.tasks[0].content,
                          );
                        },
                        icon: const Icon(Icons.mail_outline_rounded),
                        label: const Text('Hay una invitación'),
                      ),
                    ),
                  FloatingActionButton.extended(
                    heroTag: 'write-fab',
                    onPressed: () =>
                        _openWriter(notesProvider: notesProvider),
                    icon: const Icon(Icons.edit_rounded),
                    label: const Text('Escribir'),
                  ),
                ],
              ),
      ),
      body: SafeArea(
        child: notesProvider.notes.isEmpty
            ? Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                    child: HavenPageHeader(
                      kicker: isDoctor ? 'Diario compartido' : 'Tu diario',
                      title: isDoctor ? 'Páginas en silencio' : '$subjectName,',
                      subtitle: isDoctor
                          ? 'Cuando escriba, las entradas aparecerán aquí con respeto.'
                          : '${havenGreeting().toLowerCase()}. Este espacio está listo cuando tú lo estés.',
                      leading: isDoctor ? const HavenBackButton() : null,
                    ),
                  ),
                  Expanded(
                    child: HavenEmptyState(
                      icon: Icons.menu_book_rounded,
                      title: 'Todavía no hay páginas',
                      subtitle: isDoctor
                          ? 'Este diario espera la primera entrada de tu paciente.'
                          : 'No hay una forma correcta de empezar. Una frase basta.',
                      action: isDoctor
                          ? null
                          : SizedBox(
                              width: 220,
                              child: HavenButton(
                                label: 'Escribir ahora',
                                expanded: true,
                                onPressed: () =>
                                    _openWriter(notesProvider: notesProvider),
                              ),
                            ),
                    ),
                  ),
                ],
              )
            : ListView(
                padding: EdgeInsets.fromLTRB(20, 8, 20, bottomInset),
                children: [
                  HavenPageHeader(
                    kicker: isDoctor ? 'Diario acompañado' : havenGreeting(),
                    title: isDoctor ? 'Las páginas de $subjectName' : subjectName,
                    subtitle: isDoctor
                        ? 'Toca una entrada para dejar una nota clínica suave.'
                        : '¿Cómo está tu corazón hoy?',
                    leading: isDoctor ? const HavenBackButton() : null,
                  ),
                  if (!isDoctor && notesProvider.tasks.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    _TaskInvite(
                      title: notesProvider.tasks[0].title,
                      onTap: () => _openWriter(
                        notesProvider: notesProvider,
                        taskId: notesProvider.tasks[0].id,
                        taskTitle: notesProvider.tasks[0].title,
                        taskContent: notesProvider.tasks[0].content,
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  ...grouped.entries.expand((entry) {
                    return [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(4, 18, 4, 10),
                        child: Text(
                          entry.key,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ),
                      ...entry.value.map((note) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: JournalCard(
                            note: note,
                            onTap: isDoctor
                                ? () =>
                                    notesProvider.toggleNoteSelection(note.id!)
                                : null,
                            trailingAction: note.selected
                                ? Align(
                                    alignment: Alignment.centerLeft,
                                    child: TextButton.icon(
                                      onPressed: () {
                                        notesProvider.clearNotes();
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                AnotationsView(
                                              anotations:
                                                  note.notaciones ?? '',
                                              notesProvider: notesProvider,
                                              idNote: note.id!,
                                            ),
                                          ),
                                        );
                                      },
                                      icon: const Icon(
                                          Icons.edit_note_rounded),
                                      label: const Text(
                                          'Dejar una nota para la persona'),
                                    ),
                                  )
                                : null,
                          ),
                        );
                      }),
                    ];
                  }),
                ],
              ),
      ),
    );
  }
}

class _TaskInvite extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  const _TaskInvite({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final palette = havenPalette(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: palette.accentSoft,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: palette.accent.withOpacity(0.25)),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: palette.surface,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(Icons.spa_rounded, color: palette.accent),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Una invitación para escribir',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: palette.accent,
                        ),
                  ),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_rounded, color: palette.accent),
          ],
        ),
      ),
    );
  }
}
