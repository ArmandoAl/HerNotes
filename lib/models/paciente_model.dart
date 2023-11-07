import 'package:first/models/notes_model.dart';
import 'package:first/models/user_model.dart';

class PacienteModel extends UserModel {
  int? doctorId;
  List<NotesModel>? notas;

  PacienteModel({
    this.doctorId,
    this.notas,
    required String name,
    required String email,
    required String password,
    int? id,
  }) : super(
          name: name,
          email: email,
          password: password,
          id: id,
        );

  factory PacienteModel.fromJson(Map<String, dynamic> doc) {
    return PacienteModel(
      id: doc['id'],
      name: doc['name'],
      email: doc['email'],
      password: doc['password'],
      doctorId: doc['doctorId'],
      notas: [],
    );
  }
}
