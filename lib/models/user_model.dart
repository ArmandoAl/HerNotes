import 'package:first/models/notes_model.dart';

class UserModel {
  int? id;
  String name;
  String email;
  String password;
  List<NotesModel>? notas;

  UserModel({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    this.notas,
  });

  factory UserModel.fromJson(Map<String, dynamic> doc) {
    return UserModel(
      id: doc['id'],
      name: doc['name'],
      email: doc['email'],
      password: doc['password'],
      notas: [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': id,
      'name': name,
      'email': email,
      'password': password,
      'notas': notas,
    };
  }
}
