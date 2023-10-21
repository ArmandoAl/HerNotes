// ignore_for_file: file_names, use_build_context_synchronously

import 'package:first/models/contenido_model.dart';
import 'package:first/provider/notes_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/user_provider.dart';

class WriteNotePage extends StatefulWidget {
  const WriteNotePage({super.key});

  @override
  State<WriteNotePage> createState() => _WriteNotePageState();
}

class _WriteNotePageState extends State<WriteNotePage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  double mood = 0.0;

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final notesProvider = Provider.of<NotesProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escribe una nota'),
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                hintText: 'Título',
                disabledBorder: InputBorder.none,
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
            Row(
              children: [
                const Spacer(),
                Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.blue,
                  ),
                  child: IconButton(
                      onPressed: () async {
                        await showEmotionDialog(context, notesProvider,
                            userProvider, titleController, contentController);
                        notesProvider.move();
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.save)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

Future<void> showEmotionDialog(
  BuildContext context,
  NotesProvider notesProvider,
  UserProvider userProvider,
  TextEditingController titleController,
  TextEditingController contentController,
) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('¿Cómo te sientes?'),
          content: SizedBox(
            height: 200,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () {
                        notesProvider.addNote(
                            title: titleController.text,
                            content: ContenidoModel(
                                id: 2, texto: contentController.text),
                            userId: userProvider.user!.id.toString());
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        width: MediaQuery.of(context).size.width * 0.2,
                        color: Colors.orange,
                        child: const Center(
                          child: Text(
                            "Feliz",
                            style: TextStyle(fontSize: 11, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        // notesProvider.addNote(
                        //     title: titleController.text,
                        //     content: contentController.text,
                        //     date: DateTime.now().toString(),
                        //     mood: 5,
                        //     userId: userProvider.user!.uid);
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        width: MediaQuery.of(context).size.width * 0.2,
                        color: const Color.fromARGB(255, 98, 100, 102),
                        child: const Center(
                          child: Text(
                            "Indiferente",
                            style: TextStyle(fontSize: 11, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        // notesProvider.addNote(
                        //     title: titleController.text,
                        //     content: contentController.text,
                        //     date: DateTime.now().toString(),
                        //     mood: 0,
                        //     userId: userProvider.user!.uid);
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        width: MediaQuery.of(context).size.width * 0.2,
                        color: Colors.blue,
                        child: const Center(
                          child: Text(
                            "Triste",
                            style: TextStyle(fontSize: 11, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () {
                        // notesProvider.addNote(
                        //     title: titleController.text,
                        //     content: contentController.text,
                        //     date: DateTime.now().toString(),
                        //     mood: 0.75,
                        //     userId: userProvider.user!.uid);
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        width: MediaQuery.of(context).size.width * 0.2,
                        color: Colors.red,
                        child: const Center(
                          child: Text(
                            "Enojado",
                            style: TextStyle(fontSize: 11, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        // notesProvider.addNote(
                        //     title: titleController.text,
                        //     content: contentController.text,
                        //     date: DateTime.now().toString(),
                        //     mood: 0.25,
                        //     userId: userProvider.user!.uid);
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        width: MediaQuery.of(context).size.width * 0.2,
                        color: Colors.blue,
                        child: const Center(
                          child: Text(
                            "Estresado",
                            style: TextStyle(fontSize: 11, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        // notesProvider.addNote(
                        //     title: titleController.text,
                        //     content: contentController.text,
                        //     date: DateTime.now().toString(),
                        //     mood: 0.5,
                        //     userId: userProvider.user!.uid);
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        width: MediaQuery.of(context).size.width * 0.2,
                        color: Colors.red,
                        child: const Center(
                          child: Text(
                            "Ansioso",
                            style: TextStyle(fontSize: 11, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () {
                        // notesProvider.addNote(
                        //     title: titleController.text,
                        //     content: contentController.text,
                        //     date: DateTime.now().toString(),
                        //     mood: 0.75,
                        //     userId: userProvider.user!.uid);
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        width: MediaQuery.of(context).size.width * 0.2,
                        color: Colors.pink,
                        child: const Center(
                          child: Text(
                            "Enamorado",
                            style: TextStyle(fontSize: 11, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        // notesProvider.addNote(
                        //     title: titleController.text,
                        //     content: contentController.text,
                        //     date: DateTime.now().toString(),
                        //     mood: 0.25,
                        //     userId: userProvider.user!.uid);
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        width: MediaQuery.of(context).size.width * 0.2,
                        color: Colors.green,
                        child: const Center(
                          child: Text(
                            "Confundido",
                            style: TextStyle(fontSize: 11, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        // notesProvider.addNote(
                        //     title: titleController.text,
                        //     content: contentController.text,
                        //     date: DateTime.now().toString(),
                        //     mood: 0.5,
                        //     userId: userProvider.user!.uid);
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        width: MediaQuery.of(context).size.width * 0.2,
                        color: Colors.blue,
                        child: const Center(
                          child: Text(
                            "Aburrido",
                            style: TextStyle(fontSize: 11, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () {
                        // notesProvider.addNote(
                        //     title: titleController.text,
                        //     content: contentController.text,
                        //     date: DateTime.now().toString(),
                        //     mood: 0.75,
                        //     userId: userProvider.user!.uid);
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        width: MediaQuery.of(context).size.width * 0.2,
                        color: Colors.black,
                        child: const Center(
                          child: Text(
                            "Asustado",
                            style: TextStyle(fontSize: 11, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        // notesProvider.addNote(
                        //     title: titleController.text,
                        //     content: contentController.text,
                        //     date: DateTime.now().toString(),
                        //     mood: 0.25,
                        //     userId: userProvider.user!.uid);
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        width: MediaQuery.of(context).size.width * 0.2,
                        color: Colors.purple,
                        child: const Center(
                          child:
                              Text("Cansado", style: TextStyle(fontSize: 11)),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        // notesProvider.addNote(
                        //     title: titleController.text,
                        //     content: contentController.text,
                        //     date: DateTime.now().toString(),
                        //     mood: 0.5,
                        //     userId: userProvider.user!.uid);
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        width: MediaQuery.of(context).size.width * 0.2,
                        color: Colors.brown,
                        child: const Center(
                          child: Text(
                            "Avergonzado",
                            style: TextStyle(fontSize: 11, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      });
}
