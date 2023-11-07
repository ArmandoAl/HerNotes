import 'package:first/models/notes_model.dart';

class EmocionModel {
  int id;
  String tipo;
  double valor;
  List<NotesModel>? notas;
  bool selected = false;

  EmocionModel({
    required this.id,
    required this.tipo,
    required this.valor,
    this.notas,
  });

  factory EmocionModel.fromJson(Map<String, dynamic> json) {
    return EmocionModel(
      id: json['id'],
      tipo: json['tipo'],
      valor: json['valor'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tipo': tipo,
      'valor': valor,
    };
  }
}
