// ignore_for_file: file_names, use_build_context_synchronously
import 'package:first/models/contenido_model.dart';
import 'package:first/models/emocion_model.dart';
import 'package:first/models/notes_model.dart';
import 'package:first/provider/emotions_provider.dart';
import 'package:first/provider/notes_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WriteNotePage extends StatefulWidget {
  final int userId;
  final NotesProvider? notesProvider;
  const WriteNotePage({Key? key, required this.userId, this.notesProvider})
      : super(key: key);
  @override
  State<WriteNotePage> createState() => _WriteNotePageState();
}

class _WriteNotePageState extends State<WriteNotePage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  double mood = 0.0;

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
                  child: TextField(
                    controller: contentController,
                    maxLines: null,
                    decoration: const InputDecoration(
                      hintText: 'Contenido',
                      disabledBorder: InputBorder.none,
                      border: InputBorder.none,
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
          await showEmotionDialog(
            context,
            widget.notesProvider!,
            widget.userId,
            titleController,
            contentController,
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
) {
  List<EmocionModel> emociones = [];

  return showDialog(
    context: context,
    builder: (context) {
      return Consumer<EmotionProvider>(
        builder: (context, emotionProvider, child) {
          return AlertDialog(
            title: const Text('¿Cómo te sientes?'),
            content: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 8.0,
                runSpacing: 8.0,
                children: emotionProvider.emotions.map((emocion) {
                  return InkWell(
                    onTap: () {
                      emotionProvider.toggleEmotionSelection(
                          emocion.id, emociones);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width * 0.2,
                      decoration: BoxDecoration(
                        color: emocion.selected ? Colors.blue : Colors.grey,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          emocion.tipo,
                          style: const TextStyle(
                              fontSize: 11, color: Colors.white),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
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
                child: TextButton(
                  onPressed: () async {
                    await notesProvider.addNote(
                      note: NotesModel(
                        title: titleController.text,
                        content: ContenidoModel(
                          texto: contentController.text,
                        ),
                        emociones: emociones,
                      ),
                      userId: userId,
                    );
                    notesProvider.move();
                    titleController.clear();
                    contentController.clear();
                    emotionProvider.clearEmotions();
                    emociones.clear();
                    Navigator.pop(context);
                  },
                  child: const Text('Guardar',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}
