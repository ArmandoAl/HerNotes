// ignore_for_file: avoid_print
import 'dart:convert';
import 'package:first/config/api_config.dart';
import 'package:first/models/login_model.dart';
import 'package:first/models/model_for_control_usertype.dart';
import 'package:first/models/user_model.dart';
import 'package:localstorage/localstorage.dart';
import 'package:http/http.dart' as http;

class AuthService {
  //La funcion recoje los datos del usuario y los guarda en la base de datos
  Future<ModelForControlUsertype?> singUpUser(
    String email,
    String password,
    String name,
    LocalStorage storage,
  ) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty && name.isNotEmpty) {
        UserModel userModel = UserModel(
          name: name,
          email: email,
          password: password,
        );

        try {
          final response = await http.post(
            Uri.parse('$api/Usuario'),
            body: userModel.toJson(),
          );
          if (response.statusCode == 200) {
            storage.setItem("user", {
              "id": response.body,
              "name": userModel.name,
              "email": userModel.email,
              "password": userModel.password,
              "notas": [],
            });

            return ModelForControlUsertype.fromJson(jsonDecode(response.body));
          } else {
            print(response.body);
          }
        } catch (e) {
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
            storage.setItem("userStorage", response.body);

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
  Future<bool> logout(
    LocalStorage storage,
  ) async {
    storage.clear();
    return true;
  }

  Future<ModelForControlUsertype?> getStorage(LocalStorage storage) async {
    final user = await storage.getItem("userStorage");
    if (user != null) {
      final decodedUser = jsonDecode(user);
      return ModelForControlUsertype.fromJson(decodedUser);
    }
    return null;
  }
}
