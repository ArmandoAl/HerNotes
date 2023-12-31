import 'package:first/provider/notes_provider.dart';
import 'package:flutter/material.dart';

class AnotationsView extends StatefulWidget {
  final String? anotations;
  final NotesProvider notesProvider;
  final int idNote;
  const AnotationsView(
      {super.key,
      required this.anotations,
      required this.notesProvider,
      required this.idNote});

  @override
  State<AnotationsView> createState() => _AnotationsViewState();
}

class _AnotationsViewState extends State<AnotationsView> {
  TextEditingController anotationsController = TextEditingController();

  @override
  void initState() {
    anotationsController.text = widget.anotations!;
    super.initState();
  }

  // widget.anotations.replaceAll("\\n", "\n");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(''),
        ),
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              const Text("Notas para el paciente",
                  style: TextStyle(fontSize: 20)),
              const SizedBox(
                height: 8,
              ),
              Expanded(
                  child: TextField(
                controller: anotationsController,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: 'Contenido',
                  disabledBorder: InputBorder.none,
                  border: InputBorder.none,
                ),
              ))
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            widget.notesProvider
                .addNotations(anotationsController.text, widget.idNote);
            anotationsController.clear();
            Navigator.pop(context);
          },
          child: const Icon(Icons.save),
        ));
  }
}
