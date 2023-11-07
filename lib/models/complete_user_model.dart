import 'package:first/models/notes_model.dart';
import 'package:first/models/paciente_model.dart';

class CompleteUserModel {
  int id;
  String name;
  String email;
  String password;
  List<PacienteModel>? pacientes;
  int? doctorid;
  List<NotesModel>? notas;

  CompleteUserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    this.pacientes,
    this.doctorid,
    this.notas,
  });

  factory CompleteUserModel.fromJson(Map<String, dynamic> json) =>
      CompleteUserModel(
          id: json["id"],
          name: json["name"],
          email: json["email"],
          password: json["password"],
          pacientes: List<PacienteModel>.from(
              json["pacientes"].map((x) => PacienteModel.fromJson(x))),
          doctorid: json["doctorid"],
          notas: []);
}
