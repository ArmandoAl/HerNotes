// ignore_for_file: use_build_context_synchronously
import 'package:her_notes/Domain/models/contenido_model.dart';
import 'package:her_notes/Domain/models/emocion_model.dart';
import 'package:her_notes/Domain/models/notes_model.dart';
import 'package:her_notes/Domain/models/task_model.dart';
import 'package:her_notes/Presentation/provider/emotions_provider.dart';
import 'package:her_notes/Presentation/provider/notes_provider.dart';
import 'package:her_notes/Config/utils/emocion_colors.dart';
import 'package:her_notes/Config/utils/theme_provider.dart';
import 'package:her_notes/Presentation/widgets/app_message.dart';
import 'package:her_notes/Presentation/widgets/emotion_chip.dart';
import 'package:her_notes/Presentation/widgets/haven_atmosphere.dart';
import 'package:her_notes/Presentation/widgets/haven_button.dart';
import 'package:her_notes/Presentation/widgets/haven_loader.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WriteNotePage extends StatefulWidget {
  final int userId;
  final NotesProvider? notesProvider;
  final int? taskId;
  final String? taskTitle;
  final String? taskContent;
  const WriteNotePage({
    Key? key,
    required this.userId,
    this.notesProvider,
    this.taskId,
    this.taskTitle,
    this.taskContent,
  }) : super(key: key);

  @override
  State<WriteNotePage> createState() => _WriteNotePageState();
}

class _WriteNotePageState extends State<WriteNotePage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.taskTitle != null) {
      titleController.text = widget.taskTitle!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = havenPalette(context);
    final isTask = widget.taskContent != null;

    return HavenAtmosphere(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Consumer<EmotionProvider>(
          builder: (context, emotionProvider, child) {
            if (emotionProvider.emotions.isEmpty) {
              emotionProvider.getEmotions();
              return const HavenLoader(message: 'Preparando la página...');
            }

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const HavenBackButton(),
                        const Spacer(),
                        HavenButton(
                          label: 'Guardar',
                          expanded: false,
                          icon: Icons.check_rounded,
                          onPressed: () async {
                            if (contentController.text.isEmpty) {
                              showHavenMessage(
                                context,
                                'Escribe al menos una línea. No tiene que ser perfecta.',
                                isError: true,
                              );
                              return;
                            }
                            await showEmotionSheet(
                              context,
                              widget.notesProvider!,
                              widget.userId,
                              titleController,
                              contentController,
                              widget.taskId,
                              widget.taskTitle,
                              widget.taskContent,
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Text(
                      isTask
                          ? 'Responder con calma'
                          : 'Una página para ti',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      isTask
                          ? widget.taskContent!
                          : 'No hay una forma correcta de decirlo. Empieza donde puedas.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 18),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                        decoration: BoxDecoration(
                          color: palette.surface,
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(color: palette.line),
                        ),
                        child: Column(
                          children: [
                            TextField(
                              controller: titleController,
                              style: Theme.of(context).textTheme.headlineSmall,
                              decoration: const InputDecoration(
                                hintText: 'Un título, si quieres',
                                filled: false,
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                            Divider(color: palette.line),
                            Expanded(
                              child: TextField(
                                controller: contentController,
                                maxLines: null,
                                expands: true,
                                textAlignVertical: TextAlignVertical.top,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(height: 1.65),
                                decoration: InputDecoration(
                                  hintText: isTask
                                      ? 'Escribe tu respuesta aquí...'
                                      : 'Hoy siento...',
                                  filled: false,
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

Future<void> showEmotionSheet(
  BuildContext context,
  NotesProvider notesProvider,
  int userId,
  TextEditingController titleController,
  TextEditingController contentController,
  int? taskId,
  String? taskTitle,
  String? taskContent,
) {
  final List<EmocionModel> emociones = [];

  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Consumer<EmotionProvider>(
        builder: (context, emotionProvider, child) {
          final palette = havenPalette(context);
          final grouped = groupEmotionsByBase(emotionProvider.emotions);
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.78,
              ),
              padding: const EdgeInsets.fromLTRB(22, 12, 22, 24),
              decoration: BoxDecoration(
                color: palette.surface,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Column(
                children: [
                  Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: palette.line,
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    '¿Cómo te sientes ahora?',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Puedes elegir más de una. No hay emociones incorrectas.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView(
                      children: grouped.entries.map((entry) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    emotionIconOf(entry.key),
                                    size: 16,
                                    color: emotionColorOf(entry.key),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    entry.key,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(
                                          color: emotionColorOf(entry.key),
                                        ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: entry.value.map((emotion) {
                                  return SelectableEmotionChip(
                                    emotion: emotion,
                                    onTap: () {
                                      emotionProvider.toggleEmotionSelection(
                                        emotion.id,
                                        emociones,
                                      );
                                    },
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: HavenButton(
                          label: 'Ahora no',
                          variant: HavenButtonVariant.secondary,
                          onPressed: () {
                            emotionProvider.clearEmotions();
                            emociones.clear();
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Consumer<NotesProvider>(
                          builder: (context, notes, child) {
                            return HavenButton(
                              label: 'Guardar en el diario',
                              loading: notes.noteLoading,
                              onPressed: () async {
                                if (contentController.text.isEmpty) return;
                                notes.noteLoadingChange();
                                await notes.addNote(
                                  note: NotesModel(
                                    title: titleController.text,
                                    content: ContenidoModel(
                                      texto: contentController.text,
                                    ),
                                    emociones: emociones,
                                  ),
                                  userId: userId,
                                  task: taskId != null
                                      ? TaskModel(
                                          title: taskTitle!,
                                          content: taskContent!,
                                          id: taskId,
                                        )
                                      : null,
                                );
                                titleController.clear();
                                contentController.clear();
                                emotionProvider.clearEmotions();
                                emociones.clear();
                                notes.getNotes(userId);
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

Map<String, List<EmocionModel>> groupEmotionsByBase(
    List<EmocionModel> emotions) {
  final groupedEmotions = <String, List<EmocionModel>>{};
  for (final emotion in emotions) {
    groupedEmotions.putIfAbsent(emotion.emocionBase, () => []).add(emotion);
  }
  return groupedEmotions;
}

Future<void> showEmotionDialog(
  BuildContext context,
  NotesProvider notesProvider,
  int userId,
  TextEditingController titleController,
  TextEditingController contentController,
  Function setState,
  int? taskId,
  String? taskTitle,
  String? taskContent,
) {
  return showEmotionSheet(
    context,
    notesProvider,
    userId,
    titleController,
    contentController,
    taskId,
    taskTitle,
    taskContent,
  );
}
