import 'package:her_notes/Domain/models/notes_model.dart';

class AddNoteModel {
  NotesModel nota;
  int userId;
  List<int> emocionesIds;

  AddNoteModel({
    required this.nota,
    required this.userId,
    required this.emocionesIds,
  });

  Map<String, dynamic> toJson() {
    return {
      "nota": {
        "Title": nota.title,
        "Contenido": {
          "texto": nota.content.texto,
          "imagenUrl": null,
          "notaDeVozUrl": null
        },
        "Notaciones": nota.notaciones,
      },
      "userId": userId,
      "emotionsIds": emocionesIds,
    };
  }
}
