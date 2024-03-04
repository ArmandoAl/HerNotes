// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:her_notes/Config/api_config.dart';
import 'package:http/http.dart' as http;

class PacienteService {
  Future<int?> relateDoctor(int id, String tokenForRelate) async {
    try {
      final response = await http.post(
        Uri.parse('$api/Paciente/$id/relate/$tokenForRelate'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json'
        },
      );
      print(response.body);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("response error");
        print(response.body);
        return null;
      }
    } catch (e) {
      print(e);
    }

    return null;
  }
}
