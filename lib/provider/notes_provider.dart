// ignore_for_file: avoid_print

import 'package:first/models/notes_model.dart';
import 'package:first/services/notes_service.dart';
import 'package:flutter/material.dart';

class NotesProvider with ChangeNotifier {
  ScrollController notesScrollController = ScrollController();
  final NoteService _noteService = NoteService();
  final List<NotesModel> _notes = [];

  List<NotesModel> get notes => _notes;

  Future<void> addNote({
    required String title,
    required String content,
    required String date,
    required double mood,
    required String userId,
  }) async {
    final note = NotesModel(
      title: title,
      content: content,
      date: DateTime.now().toString(),
      mood: mood,
    );

    await _noteService.addNotes(userId, note);
    _notes.add(note);

    notifyListeners();
  }

  Future<List<NotesModel>> getNotes(String userId) async {
    print("getNotes");
    final response = await _noteService.getNotes(userId);
    _notes.clear();
    _notes.addAll(response);
    notifyListeners();
    return response;
  }

  void move() {
    notesScrollController.animateTo(
      notesScrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }
}
