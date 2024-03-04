// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:her_notes/Config/api_config.dart';
import 'package:her_notes/Domain/models/paciente_model.dart';
import 'package:her_notes/Domain/models/task_model.dart';
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

  Future<bool> sendNewTask(int id, TaskModel task, int pacienteId) async {
    try {
      final response = await http.post(
        Uri.parse('$api/Doctor/$id/sendTaskToPatien/$pacienteId'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json'
        },
        body: jsonEncode(task.toSend()),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      throw "Can't send task.";
    }
  }
}
