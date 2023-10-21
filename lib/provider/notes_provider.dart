// ignore_for_file: avoid_print

import 'package:first/models/contenido_model.dart';
import 'package:first/models/notes_model.dart';
import 'package:first/services/notes_service.dart';
import 'package:flutter/material.dart';

class NotesProvider with ChangeNotifier {
  ScrollController notesScrollController = ScrollController();
  final NoteService _noteService = NoteService();
  final List<NotesModel> _notes = [];
  bool loading = true;

  List<NotesModel> get notes => _notes;

  Future<void> addNote({
    required String title,
    required ContenidoModel content,
    required String userId,
  }) async {
    final note = NotesModel(
      title: title,
      content: content,
      emociones: [],
    );

    // await _noteService.addNotes(userId, note);
    _notes.add(note);

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

  void move() {
    notesScrollController.animateTo(
      notesScrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }
}
