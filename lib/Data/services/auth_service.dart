// ignore_for_file: avoid_print
import 'dart:convert';
import 'package:her_notes/Config/api_config.dart';
import 'package:her_notes/Domain/models/doctor_model.dart';
import 'package:her_notes/Domain/models/login_model.dart';
import 'package:her_notes/Domain/models/model_for_control_usertype.dart';
import 'package:her_notes/Domain/models/user_model.dart';
import 'package:localstorage/localstorage.dart';
import 'package:http/http.dart' as http;

class AuthService {
  //La funcion recoje los datos del usuario y los guarda en la base de datos
  Future<ModelForControlUsertype?> login(
      Login loginModel, LocalStorage storage) async {
    try {
      if (loginModel.email.isNotEmpty && loginModel.password.isNotEmpty) {
        try {
          final response = await http.post(
              Uri.parse('$api/Paciente/otherlogin'),
              headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json'
              },
              body: jsonEncode(loginModel.toJson()));

          if (response.statusCode == 200) {
            final decodedResponse = jsonDecode(response.body);
            //coment this line for testing
            await storage.setItem("userStorage", response.body);

            return ModelForControlUsertype.fromJson(decodedResponse);
          } else {
            print(response.body);
          }
        } catch (e) {
          print("error");
          print(e);
        }

        return null;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  //La funcion cierra la sesion del usuario
  Future<void> logout(
    LocalStorage storage,
  ) async {
    storage.clear();
  }

  Future<bool> setDoctorIdInUserStorage(int id, LocalStorage storage) async {
    final user = await storage.getItem("userStorage");
    if (user != null) {
      final decodedUser = jsonDecode(user);
      decodedUser["user"]["doctorid"] = id;
      storage.setItem("userStorage", jsonEncode(decodedUser));
      return true;
    }
    return false;
  }

  Future<ModelForControlUsertype?> getStorage(LocalStorage storage) async {
    final user = await storage.getItem("userStorage");
    if (user != null) {
      final decodedUser = jsonDecode(user);
      return ModelForControlUsertype.fromJson(decodedUser);
    }
    return null;
  }

  Future<int?> singUpPaciente(UserModel user, LocalStorage storage) async {
    try {
      final response = await http.post(
        Uri.parse('$api/Paciente'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json'
        },
        body: jsonEncode(user.toJson()),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("response error");
        print(response.body);
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<int?> singUpDoctor(DoctorModel doctor, LocalStorage storage) async {
    try {
      final response = await http.post(
        Uri.parse('$api/Doctor'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json'
        },
        body: jsonEncode(doctor.toJson()),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("response error");
        print(response.body);
      }
    } catch (e) {
      print("error");
      print(e);
    }
    return null;
  }
}
