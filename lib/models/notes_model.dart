import 'package:first/models/contenido_model.dart';
import 'package:first/models/emocion_model.dart';

class NotesModel {
  int? id;
  String title;
  ContenidoModel content;
  String? notaciones;
  List<EmocionModel>? emociones;
  bool selected = false;

  NotesModel({
    this.id,
    required this.title,
    required this.content,
    this.emociones,
    this.notaciones,
  });

  factory NotesModel.fromJson(Map<String, dynamic> doc) {
    return NotesModel(
      id: doc['id'],
      title: doc['title'],
      content: ContenidoModel.fromJson(doc['contenido']),
      notaciones: doc['notaciones'],
      emociones: doc['emociones'] != null
          ? List<EmocionModel>.from(
              doc['emociones'].map((e) => EmocionModel.fromJson(e)))
          : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'content': content,
      'emociones': emociones,
    };
  }
}
