// ignore_for_file: file_names, use_build_context_synchronously
import 'package:her_notes/Domain/models/contenido_model.dart';
import 'package:her_notes/Domain/models/emocion_model.dart';
import 'package:her_notes/Domain/models/notes_model.dart';
import 'package:her_notes/Domain/models/task_model.dart';
import 'package:her_notes/Presentation/provider/emotions_provider.dart';
import 'package:her_notes/Presentation/provider/notes_provider.dart';
import 'package:her_notes/Config/utils/emocion_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WriteNotePage extends StatefulWidget {
  final int userId;
  final NotesProvider? notesProvider;
  final int? taskId;
  final String? taskTitle;
  final String? taskContent;
  const WriteNotePage(
      {Key? key,
      required this.userId,
      this.notesProvider,
      this.taskId,
      this.taskTitle,
      this.taskContent})
      : super(key: key);

  @override
  State<WriteNotePage> createState() => _WriteNotePageState();
}

class _WriteNotePageState extends State<WriteNotePage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  bool pressed = false;

  @override
  void initState() {
    super.initState();
    if (widget.taskTitle != null) {
      titleController.text = widget.taskTitle!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Consumer<EmotionProvider>(
        builder: (context, emotionProvider, child) {
          if (emotionProvider.emotions.isEmpty) {
            emotionProvider.getEmotions();
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Container(
            margin: const EdgeInsets.all(10),
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    hintText: 'Título',
                    disabledBorder: InputBorder.none,
                    border: InputBorder.none,
                  ),
                ),
                Expanded(
                  child: Form(
                    child: TextFormField(
                      controller: contentController,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: widget.taskContent ?? 'Escribe aquí...',
                        disabledBorder: InputBorder.none,
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (contentController.text.isEmpty) return;
          await showEmotionDialog(
            context,
            widget.notesProvider!,
            widget.userId,
            titleController,
            contentController,
            () {
              setState(() {});
            },
            widget.taskId,
            widget.taskTitle,
            widget.taskContent,
          );

          Navigator.pop(context);
        },
        child: const Icon(Icons.save),
      ),
    );
  }
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
  List<EmocionModel> emociones = [];

  return showDialog(
    context: context,
    builder: (context) {
      return Consumer<EmotionProvider>(
        builder: (context, emotionProvider, child) {
          return AlertDialog(
            backgroundColor: const Color.fromARGB(255, 223, 220, 220),
            title: const Text('¿Cómo te sientes?'),
            content: Container(
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: SingleChildScrollView(
                    child: Column(
                      children:
                          _emotionList(context, emotionProvider, emociones),
                    ),
                  ),
                )),
            actions: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextButton(
                  onPressed: () {
                    emotionProvider.clearEmotions();
                    emociones.clear();
                    titleController.clear();
                    contentController.clear();
                    Navigator.pop(context);
                  },
                  child: const Text('Cancelar',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Consumer<NotesProvider>(
                  builder: (context, notesProvider, child) {
                    if (notesProvider.noteLoading) {
                      return const CircularProgressIndicator(
                        color: Colors.white,
                      );
                    }
                    return TextButton(
                      onPressed: () async {
                        if (contentController.text.isEmpty) return;
                        notesProvider.noteLoadingChange();
                        await notesProvider.addNote(
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
                                : null);
                        setState();
                        titleController.clear();
                        contentController.clear();
                        emotionProvider.clearEmotions();
                        emociones.clear();
                        notesProvider.getNotes(userId);
                        Navigator.pop(context);
                      },
                      child: const Text('Guardar',
                          style: TextStyle(color: Colors.white)),
                    );
                  },
                ),
              ),
            ],
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
    final baseEmotion = emotion.emocionBase;
    if (!groupedEmotions.containsKey(baseEmotion)) {
      groupedEmotions[baseEmotion] = [];
    }
    groupedEmotions[baseEmotion]!.add(emotion);
  }

  return groupedEmotions;
}

List<Widget> _emotionList(BuildContext context, EmotionProvider emotionProvider,
    List<EmocionModel> emocionesList) {
  List<Widget> list = [];

  // Agrupa las emociones por emoción base
  final groupedEmotions = groupEmotionsByBase(emotionProvider.emotions);

  groupedEmotions.forEach((baseEmotion, emotions) {
    list.add(
      Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: emotions.map((emotion) {
                return GestureDetector(
                  onTap: () {
                    emotionProvider.toggleEmotionSelection(
                      emotion.id,
                      emocionesList,
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: emotion.selected
                          ? Colors.black
                          : emotionColors[emotion.emocionBase]!
                              .withOpacity(0.9),
                      borderRadius: BorderRadius.circular(8),
                      border: null,
                    ),
                    child: Text(emotion.tipo,
                        style: TextStyle(
                            color:
                                emotion.selected ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold)),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  });

  return list;
}
