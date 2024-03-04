class AnotacionesModel {
  int noteId;
  String anotacion;

  AnotacionesModel({
    required this.noteId,
    required this.anotacion,
  });

  Map<String, dynamic> toJson() {
    return {
      'noteId': noteId,
      'anotacion': anotacion,
    };
  }
}
