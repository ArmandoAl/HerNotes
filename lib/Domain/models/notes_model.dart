import 'package:her_notes/Domain/models/contenido_model.dart';
import 'package:her_notes/Domain/models/emocion_model.dart';

class NotesModel {
  int? id;
  String title;
  ContenidoModel content;
  String? notaciones;
  List<EmocionModel>? emociones;
  bool selected = false;
  DateTime? fecha;
  bool isTask = true;

  NotesModel({
    this.id,
    required this.title,
    required this.content,
    this.emociones,
    this.notaciones,
    this.fecha,
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
      fecha: DateTime.parse(doc['createdDate']),
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
