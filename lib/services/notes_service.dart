// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:first/config/api_config.dart';
import 'package:first/models/notes_model.dart';
import 'package:http/http.dart' as http;

class NoteService {
  Future<String> addNotes(int userId, NotesModel note) async {
    if (note.title.isNotEmpty) {
      if (note.content.texto!.isNotEmpty ||
          note.content.imagenUrl!.isNotEmpty ||
          note.content.notaDeVozUrl!.isNotEmpty) {
        return "Note added";
      } else {
        return "Please add some content";
      }
    } else {
      return "Please fill the title";
    }
  }

  //la funcion getNotes recibe el id del usuario y devuelve una lista de notas del usuario
  Future<List<NotesModel>?> getNotes(int userId) async {
    try {
      final response =
          await http.get(Uri.parse('$api/Usuario/$userId/notas'), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      });

      if (response.statusCode == 200) {
        final List<NotesModel> notes = [];
        final List<dynamic> notesJson = jsonDecode(response.body);

        for (var element in notesJson) {
          notes.add(NotesModel.fromJson(element));
        }
        return notes;
      } else {
        print("else");
        return null;
      }
    } catch (e) {
      print("catch");
      print(e);
      return null;
    }
  }
}
