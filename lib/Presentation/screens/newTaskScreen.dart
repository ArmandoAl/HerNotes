// ignore_for_file: file_names

import 'package:her_notes/Domain/models/task_model.dart';
import 'package:her_notes/Presentation/provider/doctor_provider.dart';
import 'package:her_notes/Config/utils/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WriteNewTask extends StatefulWidget {
  final int pacienteId;
  const WriteNewTask({super.key, required this.pacienteId});

  @override
  State<WriteNewTask> createState() => _WriteNewTaskState();
}

class _WriteNewTaskState extends State<WriteNewTask> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  String pacienteName = '';

  @override
  void initState() {
    super.initState();
    final doctorProvider = Provider.of<DoctorProvider>(context, listen: false);
    pacienteName = doctorProvider.getPacienteName(widget.pacienteId) ?? '';
  }

  @override
  Widget build(BuildContext context) {
    DoctorProvider doctorProvider =
        Provider.of<DoctorProvider>(context, listen: false);
    ThemeProvider theme = Provider.of<ThemeProvider>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        shadowColor: theme.isDarkModeEnabled
            ? theme.dark['shadowColor']
            : theme.light['shadowColor'],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
        centerTitle: true,
        title: Text('Nueva tarea para $pacienteName',
            style: TextStyle(
                color: theme.isDarkModeEnabled ? Colors.white : Colors.black)),
        backgroundColor: theme.isDarkModeEnabled
            ? theme.dark['backgroundColor']
            : theme.light['backgroundColor'],
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back_ios_new,
                  color: Color.fromRGBO(47, 137, 252, 1)),
              iconSize: 30,
              onPressed: () {
                Navigator.pop(context);
              },
            );
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: theme.isDarkModeEnabled
              ? theme.dark['backgroundColor']
              : theme.light['backgroundColor'],
        ),
        padding: const EdgeInsets.all(10),
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final task = TaskModel(
            title: titleController.text,
            content: contentController.text,
            isDone: false,
          );
          await doctorProvider.sendNewTask(task, widget.pacienteId);
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}
