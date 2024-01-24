import 'dart:convert';

import 'package:first/config/api_config.dart';
import 'package:first/models/paciente_model.dart';
import 'package:first/models/task_model.dart';
import 'package:http/http.dart' as http;

class DoctorService {
  Future<List<PacienteModel>> getPacientes(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$api/Doctor/$id/GetAllUsers'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json'
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        List<PacienteModel> pacientes =
            body.map((dynamic item) => PacienteModel.fromJson(item)).toList();
        return pacientes;
      } else {
        throw "Else";
      }
    } catch (e) {
      throw "Can't get pacientes.";
    }
  }

  Future<bool> sendNewTask(TaskModel task, int pacienteId) async {
    try {
      final response = await http.post(
        Uri.parse('$api/Paciente/$pacienteId/AddTask'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json'
        },
        body: jsonEncode(task.toJson()),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw "Else";
      }
    } catch (e) {
      throw "Can't get pacientes.";
    }
  }
}
