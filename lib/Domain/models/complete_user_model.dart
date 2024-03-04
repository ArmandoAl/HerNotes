import 'package:her_notes/Domain/models/notes_model.dart';
import 'package:her_notes/Domain/models/paciente_model.dart';
import 'package:her_notes/Domain/models/task_model.dart';

class CompleteUserModel {
  int id;
  String name;
  String email;
  String password;
  List<PacienteModel>? pacientes;
  int? doctorid;
  List<NotesModel>? notas;
  String? cedulaProfesional;
  List<TaskModel>? tareas;
  String token = "";
  String? tokenForRelate;

  CompleteUserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    this.pacientes,
    this.doctorid,
    this.notas,
    this.cedulaProfesional,
    this.tareas,
    this.token = "",
    this.tokenForRelate,
  });

  factory CompleteUserModel.fromJson(Map<String, dynamic> json) =>
      CompleteUserModel(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        password: json["password"],
        pacientes: [],
        doctorid: json["doctorid"],
        notas: [],
        cedulaProfesional: "",
        tareas: [],
        token: json["token"],
        tokenForRelate: json["tokenForRelate"],
      );
}
