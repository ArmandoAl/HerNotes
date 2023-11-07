import 'package:first/models/paciente_model.dart';
import 'package:first/models/user_model.dart';

class DoctorModel extends UserModel {
  List<PacienteModel>? pacientes;

  DoctorModel({
    this.pacientes,
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

  factory DoctorModel.fromJson(Map<String, dynamic> doc) {
    return DoctorModel(
      id: doc['id'],
      name: doc['name'],
      email: doc['email'],
      password: doc['password'],
      pacientes: [
        PacienteModel(
          id: 5,
          name: 'Armando',
          email: "test",
          password: "test",
        ),
      ],
    );
  }
}
