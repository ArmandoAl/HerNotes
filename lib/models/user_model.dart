import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String uid;
  String name;
  String email;
  String password;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.password,
  });

  factory UserModel.fromJson(DocumentSnapshot doc) {
    return UserModel(
      uid: doc['uid'],
      name: doc['name'],
      email: doc['email'],
      password: doc['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'password': password,
    };
  }
}
