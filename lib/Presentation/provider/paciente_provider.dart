import 'package:her_notes/Data/services/pacient_service.dart';
import 'package:her_notes/Domain/models/model_for_control_usertype.dart';
import 'package:her_notes/Domain/models/paciente_model.dart';
import 'package:flutter/material.dart';

class PacienteProvider extends ChangeNotifier {
  bool loading = true;
  PacienteModel? paciente;
  PacienteModel? get getPaciente => paciente;
  final PacienteService _pacienteService = PacienteService();

  Future<void> setPaciente(ModelForControlUsertype paciente) async {
    this.paciente = PacienteModel(
      id: paciente.user.id,
      name: paciente.user.name,
      email: paciente.user.email,
      password: paciente.user.password,
      doctorId: paciente.user.doctorid,
      notas: paciente.user.notas,
      token: paciente.user.token,
    );
    loading = false;
    notifyListeners();
  }

  Future<int?> relateDoctor(int id, String tokenForRelate) async {
    final response = await _pacienteService.relateDoctor(id, tokenForRelate);
    if (response != null) {
      paciente!.doctorId = response;
      notifyListeners();
      return response;
    }
    notifyListeners();
    return null;
  }

  void clearPaciente() {
    paciente = null;
    loading = true;
    notifyListeners();
  }
}
