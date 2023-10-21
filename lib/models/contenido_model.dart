class ContenidoModel {
  int id;
  String? texto;
  String? imagenUrl;
  String? notaDeVozUrl;

  ContenidoModel({
    required this.id,
    this.texto,
    this.imagenUrl,
    this.notaDeVozUrl,
  });

  factory ContenidoModel.fromJson(Map<String, dynamic> json) {
    return ContenidoModel(
      id: json['id'],
      texto: json['texto'],
      imagenUrl: json['imagenUrl'],
      notaDeVozUrl: json['notaDeVozUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'texto': texto,
      'imagenUrl': imagenUrl,
      'notaDeVozUrl': notaDeVozUrl,
    };
  }
}
