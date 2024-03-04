// ignore_for_file: avoid_print
import 'package:her_notes/Domain/models/add_note_model.dart';
import 'package:her_notes/Domain/models/anotaciones_model.dart';
import 'package:her_notes/Domain/models/notes_&_task_model.dart';
import 'package:her_notes/Domain/models/notes_model.dart';
import 'package:her_notes/Data/services/notes_service.dart';
import 'package:her_notes/Domain/models/task_model.dart';
import 'package:flutter/material.dart';

class NotesProvider extends ChangeNotifier {
  ScrollController notesScrollController = ScrollController();
  List<NotesModel> notes = [];
  List<TaskModel> tasks = [];
  final NoteService _noteService = NoteService();
  bool loading = true;
  bool noteLoading = false;
  bool newTaskHover = false;

  List<NotesModel> get takeNotes => notes;
  List<TaskModel> get takeTasks => tasks;

  Future<void> addNote({
    required NotesModel note,
    required int userId,
    TaskModel? task,
  }) async {
    final emocionesIds = note.emociones!.map((e) => e.id).toList();

    final addNoteModel = AddNoteModel(
      nota: note,
      userId: userId,
      emocionesIds: emocionesIds,
    );

    int id = await _noteService.addNote(addNoteModel, task, userId);
    if (id != -1) {
      note.id = id;
      note.fecha = DateTime.now();
      notes.add(note);
      tasks.removeWhere((element) => element.id == task?.id);
      noteLoading = false;
      notifyListeners();
      return;
    }

    noteLoading = false;
    notifyListeners();
  }

  Future<void> getNotes(int id) async {
    // if (!loading) return;
    NotesAndTaskModel? response = await _noteService.getNotes(id);
    if (response != null) {
      notes = response.notes!;
      tasks = response.tasks!;
    }
    loading = false;
    notifyListeners();
  }

  Future<void> addNotations(String notations, int noteId) async {
    await _noteService.addNotations(AnotacionesModel(
      noteId: noteId,
      anotacion: notations,
    ));

    final note = notes.firstWhere((e) => e.id == noteId);
    note.notaciones = notations;
    notifyListeners();
  }

  void move() {
    notesScrollController.animateTo(
      notesScrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void toggleNoteSelection(int id) {
    //all the notes that are selected will be unselected except the one with the id
    for (var element in notes) {
      if (element.id != id) {
        element.selected = false;
      }
    }

    //the note with the id will be selected if it was not selected
    final note = notes.firstWhere((element) => element.id == id);
    note.selected = !note.selected;

    notifyListeners();
  }

  void clearNotes() {
    //all the notes will be unselected
    for (var element in notes) {
      element.selected = false;
    }
    notifyListeners();
  }

  void noteLoadingChange() {
    noteLoading = true;
    notifyListeners();
  }

  void setNewTaskHover(bool state) {
    newTaskHover = state;
    notifyListeners();
  }

  void clearProvider() {
    notes = [];
    tasks = [];
    loading = true;
    noteLoading = false;
    newTaskHover = false;
    notifyListeners();
  }
}
