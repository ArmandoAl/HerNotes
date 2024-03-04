// ignore_for_file: avoid_print
import 'dart:convert';
import 'package:her_notes/Config/api_config.dart';
import 'package:her_notes/Domain/models/add_note_model.dart';
import 'package:her_notes/Domain/models/anotaciones_model.dart';
import 'package:her_notes/Domain/models/notes_&_task_model.dart';
import 'package:her_notes/Domain/models/task_model.dart';
import 'package:http/http.dart' as http;

class NoteService {
  Future<int> addNote(
      AddNoteModel addNoteModel, TaskModel? task, int id) async {
    try {
      final response = await http.post(Uri.parse('$api/Nota'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: jsonEncode(addNoteModel.toJson()));
      if (response.statusCode == 200) {
        if (task != null) {
          try {
            final taskResponse = await http.post(
              Uri.parse('$api/Paciente/$id/completeTaskAndNotiDoctor'),
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
              },
              body: jsonEncode(task.toJson()),
            );
            if (taskResponse.statusCode != 200) {
              return 0;
            }
          } catch (e) {
            print(e);
            return 0;
          }
        }
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
  Future<NotesAndTaskModel?> getNotes(int userId) async {
    try {
      final response =
          await http.get(Uri.parse('$api/Paciente/$userId/notas'), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      });
      if (response.statusCode == 200) {
        final notesAndTask =
            NotesAndTaskModel.fromJson(jsonDecode(response.body));
        return notesAndTask;
      } else {
        return null;
      }
    } catch (e) {
      print("Error en getNotes");
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
