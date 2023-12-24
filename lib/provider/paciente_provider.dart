import 'package:first/models/model_for_control_usertype.dart';
import 'package:first/models/paciente_model.dart';
import 'package:flutter/material.dart';

class PacienteProvider extends ChangeNotifier {
  bool loading = true;
  PacienteModel? paciente;
  PacienteModel? get getPaciente => paciente;

  Future<void> setPaciente(ModelForControlUsertype paciente) async {
    this.paciente = PacienteModel(
      id: paciente.user.id,
      name: paciente.user.name,
      email: paciente.user.email,
      password: paciente.user.password,
      doctorId: paciente.user.doctorid,
      notas: paciente.user.notas,
    );
    loading = false;
    notifyListeners();
  }
}
