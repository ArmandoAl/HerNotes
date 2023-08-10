import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first/models/notes_model.dart';

class NoteService {
  final _notesCollection = FirebaseFirestore.instance;
  //la funcion addNotes recibe los datos del usuario y los guarda en la base de datos, en la coleccion notes, en el documento del usuario, en la coleccion userNotes, en un documento con un id aleatorio
  Future<String> addNotes(String userId, NotesModel note) async {
    if (note.title.isNotEmpty && note.content.isNotEmpty) {
      await _notesCollection
          .collection('notes')
          .doc(userId)
          .collection('userNotes')
          .add(note.toFirestore());
      return "Note added";
    } else {
      return "Please fill all the fields";
    }
  }

  //la funcion getNotes recibe el id del usuario y devuelve una lista de notas del usuario
  Future<List<NotesModel>> getNotes(String userId) async {
    List<NotesModel> notes = [];
    await _notesCollection
        .collection('notes')
        .doc(userId)
        .collection('userNotes')
        .get()
        .then((value) {
      for (var element in value.docs) {
        notes.add(NotesModel.fromFirestore(element));
      }
    });
    return notes;
  }
}
