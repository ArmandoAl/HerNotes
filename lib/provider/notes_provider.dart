// ignore_for_file: avoid_print
import 'package:first/models/add_note_model.dart';
import 'package:first/models/anotaciones_model.dart';
import 'package:first/models/notes_model.dart';
import 'package:first/services/notes_service.dart';
import 'package:flutter/material.dart';

class NotesProvider with ChangeNotifier {
  ScrollController notesScrollController = ScrollController();
  final NoteService _noteService = NoteService();
  final List<NotesModel> _notes = [];
  bool loading = true;
  bool noteLoading = false;

  List<NotesModel> get notes => _notes;

  Future<void> addNote({
    required NotesModel note,
    required int userId,
  }) async {
    final emocionesIds = note.emociones!.map((e) => e.id).toList();

    final addNoteModel = AddNoteModel(
      nota: note,
      userId: userId,
      emocionesIds: emocionesIds,
    );

    int id = await _noteService.addNote(addNoteModel);
    note.id = id;
    note.fecha = DateTime.now();

    _notes.add(note);

    noteLoading = false;

    notifyListeners();
  }

  Future<void> getNotes(int id) async {
    if (!loading) return;
    List<NotesModel>? response = await _noteService.getNotes(id);
    if (response != null) {
      _notes.clear();
      _notes.addAll(response);
    }
    loading = false;
    notifyListeners();
  }

  Future<void> addNotations(String notations, int noteId) async {
    await _noteService.addNotations(AnotacionesModel(
      noteId: noteId,
      anotacion: notations,
    ));

    final note = _notes.firstWhere((e) => e.id == noteId);
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
    for (var element in _notes) {
      if (element.id != id) {
        element.selected = false;
      }
    }

    //the note with the id will be selected if it was not selected
    final note = _notes.firstWhere((element) => element.id == id);
    note.selected = !note.selected;

    notifyListeners();
  }

  void clearNotes() {
    //all the notes will be unselected
    for (var element in _notes) {
      element.selected = false;
    }
    notifyListeners();
  }

  void noteLoadingChange() {
    noteLoading = true;
    notifyListeners();
  }
}
