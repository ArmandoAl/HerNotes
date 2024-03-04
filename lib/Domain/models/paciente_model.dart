import 'package:her_notes/Domain/models/notes_model.dart';
import 'package:her_notes/Domain/models/task_model.dart';
import 'package:her_notes/Domain/models/user_model.dart';

class PacienteModel extends UserModel {
  int? doctorId;
  List<NotesModel>? notas;
  List<TaskModel>? tareas;

  PacienteModel({
    this.doctorId,
    this.notas,
    required String name,
    required String email,
    required String password,
    required String token,
    int? id,
  }) : super(
          name: name,
          email: email,
          password: password,
          id: id,
          token: token,
        );

  factory PacienteModel.fromJson(Map<String, dynamic> doc) {
    return PacienteModel(
      id: doc['id'],
      name: doc['name'],
      email: doc['email'],
      password: doc['password'],
      doctorId: doc['doctorId'],
      notas: [],
      token: doc['token'],
    );
  }
}
