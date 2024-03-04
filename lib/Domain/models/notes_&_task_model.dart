// ignore_for_file: file_names

import 'package:her_notes/Domain/models/notes_model.dart';
import 'package:her_notes/Domain/models/task_model.dart';

class NotesAndTaskModel {
  List<NotesModel>? notes;
  List<TaskModel>? tasks;

  NotesAndTaskModel({this.notes, this.tasks});

  NotesAndTaskModel.fromJson(Map<String, dynamic> json) {
    if (json['notas'] != null) {
      notes = <NotesModel>[];
      json['notas'].forEach((v) {
        notes!.add(NotesModel.fromJson(v));
      });
    }
    if (json['tareas'] != null) {
      tasks = <TaskModel>[];
      json['tareas'].forEach((v) {
        tasks!.add(TaskModel.fromJson(v));
      });
    }
  }
}
