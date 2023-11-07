// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:first/config/api_config.dart';
import 'package:first/models/add_note_model.dart';
import 'package:first/models/anotaciones_model.dart';
import 'package:first/models/notes_model.dart';
import 'package:http/http.dart' as http;

class NoteService {
  Future<int> addNote(AddNoteModel addNoteModel) async {
    try {
      final response = await http.post(Uri.parse('$api/Nota'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: jsonEncode(addNoteModel.toJson()));
      if (response.statusCode == 200) {
        print(response.body);
        return jsonDecode(response.body);
      } else {
        return 0;
      }
    } catch (e) {
      print(e);
      return 0;
    }
  }

  //la funcion getNotes recibe el id del usuario y devuelve una lista de notas del usuario
  Future<List<NotesModel>?> getNotes(int userId) async {
    try {
      final response =
          await http.get(Uri.parse('$api/Paciente/$userId/notas'), headers: {
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
      print("catch notas");
      print(e);
      return null;
    }
  }

  Future<void> addNotations(AnotacionesModel model) async {
    try {
      final response = await http.put(
        Uri.parse('$api/Nota/addNotations'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(model.toJson()),
      );
      if (response.statusCode == 200) {
        print(response.body);
      } else {
        print(response.body);
      }
    } catch (e) {
      print(e);
    }
  }
}
