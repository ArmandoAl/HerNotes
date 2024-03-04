import 'package:her_notes/Domain/models/paciente_model.dart';
import 'package:her_notes/Domain/models/user_model.dart';

class DoctorModel extends UserModel {
  String? cedulaProfesional;
  List<PacienteModel>? pacientes;
  String? tokenForRelate;

  DoctorModel({
    this.tokenForRelate,
    this.pacientes,
    this.cedulaProfesional,
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

  factory DoctorModel.fromJson(Map<String, dynamic> doc) {
    return DoctorModel(
      id: doc['id'],
      name: doc['name'],
      email: doc['email'],
      password: doc['password'],
      cedulaProfesional: doc['cedulaProfesional'],
      pacientes: [
        for (var paciente in doc['pacientes'])
          PacienteModel.fromJson(paciente as Map<String, dynamic>)
      ],
      token: doc['token'],
      tokenForRelate: doc['tokenForRelate'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'cedulaProfesional': cedulaProfesional,
      'token': token,
    };
  }
}
